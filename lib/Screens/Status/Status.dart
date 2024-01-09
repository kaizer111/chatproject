import 'package:chattingapp/Constants/databseConstants.dart';
import 'package:chattingapp/Dummy_data/data.dart';
import 'package:chattingapp/Screens/Status/display_status.dart';
import 'package:chattingapp/services/firebase/storage_serv.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chattingapp/Constants/device_size.dart';
import 'package:chattingapp/Screens/editScreen.dart';
import 'package:chattingapp/model/User_model.dart';
import 'package:chattingapp/services/api/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constants/device_size.dart';
import 'package:photo_view/photo_view.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';

class Status extends StatefulWidget {
   Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
   Future<XFile?> pickimage () async{
  final ImagePicker  picker = ImagePicker();
   XFile? image= await picker.pickImage(source: ImageSource.gallery);
   return image;
  }

  List<dynamic> friends = [];
  List<String> names = [];
  List<String> time = [];
   String myUid = FirebaseAuth.instance.currentUser!.uid;
   bool alreadyfound=false;
   String? mystatusimage;

  @override
  void initState() {
    super.initState();
    checkmystatus();

  }

  checkmystatus() async{
    var stdetail = await statusDb.doc(myUid).get();
    if(stdetail.exists) {
     mystatusimage = stdetail.data()!['imag'];
      setState(() {
        
      });
    }
  }

 Future<dynamic> getMyFriends()async{
     final friendsResponse = await friendsDb.doc(myUid).get();
     friends = friendsResponse.data()!['friends']; // fetching list of existing friends
    for(int i=0;i<friends.length;i++){
      var f = friends[i];
      print(f.toString());
      var fdetail = await userdb.doc(f.toString()).get();
      print(fdetail.data());
       names.add(UserModel.fromJson(fdetail.data()!).name) ;
    }
    if(!alreadyfound) {
      setState(() {
      alreadyfound = true;
    });
    }
    
     return friends;
  }

  deleteMyStatus()async{
    await statusDb.doc(myUid).delete();
    mystatusimage=null;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: (mystatusimage!=null)? CircleAvatar(
              backgroundImage: NetworkImage(mystatusimage!),
              
            ):CircleAvatar(
              backgroundColor: Color.fromARGB(255, 145, 193, 232),
              child: Icon(Icons.add),
            ),
            title: Text('My Status'),
            onTap: () {
              showImageViewer(
                        context,
                        Image.network(mystatusimage!).image,
                        swipeDismissible: true,
                    doubleTapZoomable: true,
                    useSafeArea: true
                    );
            },
            trailing: IconButton(
              onPressed: () {
              deleteMyStatus();
            }, icon: Icon(Icons.delete)),
          ),
          Divider(),
          Expanded(
            child: FutureBuilder(
              future: getMyFriends(),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot fsnap) {
                print("ok");
                if(fsnap.hasData){
                   return StreamBuilder(
              stream: statusDb.where('userid',whereIn: friends).snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                print("here ok too");
                if(snapshot.hasData){
                  print('heyy');
                   return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  print('working');
                  var statustime = snapshot.data.docs[index]['time'];
                  var parsedtime = DateFormat('dd-MM-yyyy', 'en_US').parse(statustime);
                  return ListTile(
                    onTap: () {
                      showImageViewer(
                        context,
                        Image.network(snapshot.data.docs[index]['imag']).image,
                        swipeDismissible: true,
                    doubleTapZoomable: true,
                    useSafeArea: true
                    );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data.docs[index]['imag'],),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(names[index]),
                    subtitle: Text((DateFormat.jms().format(parsedtime))),
                  );
                },
              );
                }
                else{
                   return LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blue.shade100,
                    size: 200,
                  );
                }
             
            },);
                }
                else{
                  return LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blue.shade100,
                    size: 200,
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async{
       XFile? img = await pickimage();
       if(img!=null){
          String? imageUrl = await getImageUrl(File(img.path),"status/${myUid}/1");
          await statusDb.doc(myUid).set({'imag':imageUrl,'time':DateTime.now().toString()});
       }

      },
      
      ),

    
    );
  }
}
