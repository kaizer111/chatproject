import 'package:chattingapp/Constants/databseConstants.dart';
import 'package:chattingapp/Screens/chats/chattingroom.dart';
import 'package:chattingapp/Screens/floatingbutton_Actions/Qr_Code_generator/Qr_generator.dart';
import 'package:chattingapp/Screens/floatingbutton_Actions/Qr_Scanner/Qr_Scanner.dart';
import 'package:chattingapp/model/User_model.dart';
import 'package:chattingapp/model/chat_room_model.dart';
import 'package:chattingapp/services/api/utils.dart';
import 'package:chattingapp/services/firebase/generateChatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class chats extends StatefulWidget {
  @override
  State<chats> createState() => _chatsState();
}

class _chatsState extends State<chats> with TickerProviderStateMixin{
  //const chats({super.key});
  String myuid= FirebaseAuth.instance.currentUser!.uid;

    Animation<double>? _animation;
   AnimationController? _animationController;

  @override
  void initState() {
     super.initState();
       _animationController = AnimationController(
        vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(
      stream: chatroomdb.where('users',arrayContains: myuid).snapshots(),
      builder: (context,AsyncSnapshot snapshot) {
       
      if(snapshot.hasData || (snapshot.connectionState==ConnectionState.active || snapshot.connectionState==ConnectionState.done)) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var listilechattime = DateTime.parse(snapshot.data.docs[index]['lastchattime']);
              String otherId = myuid==snapshot.data.docs[index]['users'][0]?snapshot.data.docs[index]['users'][1]:snapshot.data.docs[index]['users'][0];
              var k=snapshot.data.docs[index]['users'];
              return  FutureBuilder(
                future: getUserDetails(otherId),
                builder: (BuildContext context, AsyncSnapshot<UserModel> usersnapshot) {
                  if(usersnapshot.hasData) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChattingRoom(chatRoomId:snapshot.data.docs[index]['chatroomid'] , otherUser:usersnapshot.data! ),));
                      },
                tileColor: Colors.white,
              visualDensity: VisualDensity(vertical: 2.5),
              leading: CircleAvatar(
                child: Icon(Icons.account_box),   // instead of this icon this will be the persons profile picture
              ),
              title: Text(usersnapshot.data!.name),
              subtitle: Text('Latest chats',style: TextStyle(fontFamily: "open"),),
              trailing: Text(timeago.format(listilechattime,allowFromNow: true)), // this will show the current time
            );
                  }
                  else {
                    return LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blue.shade100,
                    size: 200,
                  );;
                  }
                },
              );
            },
          );
      }
      else {
        return LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blue.shade100,
                    size: 10,
                  );;
      }
    },),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton:  FloatingActionBubble(
        // Menu items
        items: [

          // Floating action menu item
          Bubble(
            title:"QuickScan",
            iconColor :Colors.white,
            bubbleColor : Colors.blue,
            icon:Icons.qr_code_scanner,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              _animationController!.reverse();
              Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanner(),));
            },
          ),
          // Floating action menu item
          Bubble(
            title:"QuickQr",
            iconColor :Colors.white,
            bubbleColor : Colors.blue,
            icon:Icons.qr_code,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              _animationController!.reverse();
              Navigator.push(context, MaterialPageRoute(builder: (context) => QrGenerator(),));

            },
          ),
          //Floating action menu item
          
        ],

        // animation controller
        animation: _animation!,

        // On pressed change animation state
        onPress: () => _animationController!.isCompleted
              ? _animationController!.reverse()
              : _animationController!.forward(),

        
        // Floating Action button Icon color
        iconColor: Colors.white,

        // Flaoting Action button Icon 
        iconData: Icons.add, 
        backGroundColor: Colors.blue,
      ),
    );
  }
}