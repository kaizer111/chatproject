import 'dart:io';
import 'package:chattingapp/Constants/device_size.dart';
import 'package:chattingapp/Screens/editScreen.dart';
import 'package:chattingapp/model/User_model.dart';
import 'package:chattingapp/services/api/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String myUid = FirebaseAuth.instance.currentUser!.uid;

   XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyle(
                color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold
            )
        ),
        centerTitle: true,
        //backgroundColor: Color.fromARGB(255, 145, 193, 232),
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getUserDetails(myUid),
          builder: (context, AsyncSnapshot<UserModel> snapshot) {
            if(snapshot.hasData) {
              return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height:displayHeight(context)*0.17,
                    width:displayWidth(context)*0.31,
                    child: InkWell(
                      child: CircleAvatar(
                        backgroundImage: (image!=null)
                        ?FileImage(File(image!.path))
                        :AssetImage('assets/images/chattingicon.png') as ImageProvider
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context, builder: (context) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('view profile photo'),
                                ),
                                ListTile(
                                  title: Text('change profile poto'),
                                  onTap: () async{
                                    await pickimage();
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                        },); 
                      },
                    ),
                  ),
                  SizedBox(
                    height: displayHeight(context)*0.01,
                  ),
                  Text(snapshot.data!.name,
                    style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w500),
                  ),
        
                  SizedBox(
                    height: displayHeight(context)*0.01,
                  ),
                  Text('Hii, I am Mohit',
                    style: TextStyle(fontSize: 20,
                        //fontWeight: FontWeight.w500
                      ),
                  ),
        
                  // SizedBox(
                  //   height: displayHeight(context)*0.017,
                  // ),
                  // SizedBox(
                  //   height: displayHeight(context)*0.06,
                  //   width: displayWidth(context)*0.5,
                  //   child: MaterialButton(
                  //     onPressed: (){
                  //       // Navigator.pop(context);
                  //       // Navigator.push(context,
                  //       //     MaterialPageRoute(builder: (context) => EditScreen()));
                  //     },
                  //     child: Text('Edit Profile',
                  //       style: TextStyle(fontSize: 19,
                  //         color: Colors.white
                  //       ),
                  //     ),
                  //     color: Colors.black,
                  //     shape: StadiumBorder(),
                  //   ),
                  // ),
        
                  SizedBox(
                    height: displayHeight(context)*0.017,
                  ),
                  const Divider(),
        
                  ListTile(
                    trailing: Icon(Icons.edit),
                    leading: Icon(Icons.cake,size: 37,),
                    title: Text('Birthday',
                      style: TextStyle(color: Colors.black,
                          fontSize: 16,
                      ),
                    ),
                    subtitle: Text('13/08/2000',
                      style: TextStyle(color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
        
                  ListTile(
                    trailing: Icon(Icons.edit),
                    leading: Icon(Icons.boy,size: 48,),
                    title: Text('Gender',
                      style: TextStyle(color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text('Male',
                      style: TextStyle(color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
        
                  ListTile(
                    trailing: Icon(Icons.edit),
                    leading: Icon(Icons.phone,size: 39,),
                    title: Text('Email',
                      style: TextStyle(color: Colors.black,
                          fontSize: 16,
                      ),
                    ),
                    subtitle: Text('mohit123@gmail.com',
                      style: TextStyle(color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  MaterialButton(
                      onPressed: (){
                        // Navigator.pop(context);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => EditScreen()));
                      },
                      child: Text('Update Profile',
                        style: TextStyle(fontSize: 19,
                          color: Colors.white
                        ),
                      ),
                      color: Colors.black,
                      shape: StadiumBorder(),
                    ),
                ],
              ),
            ),
          );
            }
            else {
              return CircularProgressIndicator();
            }
          },    
        ),
      ),
    );
  }

 Future<XFile?> pickimage () async{
  final ImagePicker  picker = ImagePicker();
   XFile? image= await picker.pickImage(source: ImageSource.gallery);
   return image;
  }


}


