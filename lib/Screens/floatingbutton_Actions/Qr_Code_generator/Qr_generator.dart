import 'package:chattingapp/controllers/user_controller.dart';
import 'package:chattingapp/model/User_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class QrGenerator extends StatefulWidget {
  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  //QrGenerator({super.key});
  final String myUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // const SizedBox(
          //   height: 30,
          // ),
          Center(
            child: CircleAvatar(
              child: Container(child: Image.asset("assets/images/chattingicon.png",fit: BoxFit.contain,)),
              backgroundColor: Colors.blue[200],
              radius: 45,
            )),
            const SizedBox(
              height: 15,
            ),
             Center(child: Text(userController.currentUser!=null? 
              "${userController.currentUser!.name}":'anonymus',
              style: TextStyle(
                fontSize: 25,
                fontFamily: "fira",
                ),)),
            const SizedBox(
            height: 30,
          ),
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.blue,
              backgroundBlendMode: BlendMode.colorBurn,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Center(
              child: QrImage(
                data: myUserId,
                backgroundColor: Colors.white,
                size: 200,
                ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          MaterialButton(
            color: Colors.blue[200],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: const Icon(Icons.share),
            onPressed: () {
             Share.share(' first try');
          },)
        ],
      ),
    );
  }
}