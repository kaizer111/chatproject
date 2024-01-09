import 'package:chattingapp/Constants/device_size.dart';
import 'package:chattingapp/Screens/Help.dart';
import 'package:chattingapp/Screens/Starred_messages.dart';
import 'package:chattingapp/Screens/Status/display_status.dart';
import 'package:chattingapp/Screens/calls/calls.dart';
import 'package:chattingapp/Screens/chats/chats.dart';
import 'package:chattingapp/Screens/floatingbutton_Actions/Qr_Code_generator/Qr_generator.dart';
import 'package:chattingapp/Screens/floatingbutton_Actions/Qr_Scanner/Qr_Scanner.dart';
import 'package:chattingapp/Screens/groups/groups.dart';
import 'package:chattingapp/Screens/newGroups.dart';
import 'package:chattingapp/Screens/profile.dart';
import 'package:chattingapp/Screens/settings.dart';
import 'package:chattingapp/controllers/user_controller.dart';
import 'package:chattingapp/enum/enums.dart';
import 'package:chattingapp/main.dart';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'Screens/Status/Status.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
 late TabController _tabController;
  Animation<double>? _animation;
   AnimationController? _animationController;
  
  
  @override
  void initState() {
     super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    
   
  }

  @override
 
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              actions: [
                PopupMenuButton(onSelected: (value){
            print(value);
            },
        color: Colors.blueGrey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(child: ListTile(
            leading: Text('Profile',
              style: TextStyle(
                  fontSize: 16
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile(),));
            },
          )
          ),
          
          PopupMenuItem(child: ListTile(
            leading: Text('Help',
              style: TextStyle(
                  fontSize: 16
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HelpScreen()));
            },
          )
          ),

          PopupMenuItem(child: ListTile(
            leading: Text('Logout',
              style: TextStyle(
                  fontSize: 16
              ),
            ),
            onTap: () async{
              Navigator.pop(context);
              await setPref(false);
              Navigator.pushReplacementNamed(context, '/AppScreen');
            },
          )
          ),

        ];
      }
    ),
              ],
              title: Text("QuickChat",style: TextStyle(fontSize: 30,fontFamily: "fira")),
              backgroundColor: Color.fromARGB(255, 145, 193, 232),
              pinned: true,
            snap: false,
            floating: true,
             bottom:  TabBar
             (
              labelStyle: TextStyle(fontFamily: "fira"),
              controller: _tabController,
              indicatorColor: Colors.black,
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const UnderlineTabIndicator(
              insets: EdgeInsets.only(bottom: 2),
             ),
              tabs: const [
               Tab(text: 'Chats',),
               Tab(text: 'Status'),
            ],
            ),
            ),
            SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children:  [
                Center(
                  child:  Consumer<UserController>(
          builder: (context, userctr, child) {
            if(userctr.userStatus==UserStatus.NIL){
              userctr.setUser(FirebaseAuth.instance.currentUser!.uid);
            }
            switch(userctr.userStatus){
              case UserStatus.DONE:
               return chats();
              case UserStatus.LOADING:
                return Center(child: CircularProgressIndicator());
              case UserStatus.NIL:
                return CircularProgressIndicator();
            }
          },
        ),
                
                ),
                Center(child: Status()),
              ],
            ),
          ),
          ],
          
        ),
       
      ),
    );
  }
}
