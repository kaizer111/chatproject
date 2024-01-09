import 'package:chattingapp/model/User_model.dart';
import 'package:chattingapp/services/api/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpScreen extends StatelessWidget {
  String myuid=FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text('Help',style: TextStyle(fontFamily: 'fira'),),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Icon(Icons.help),
          ),
        ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                child: Text("Reach us",style: TextStyle(fontSize: 26,fontFamily: 'fira', fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                child: Text('If you have any king of issue regarding the application , do submit your valuable feedback here.  Suggetions are most welcome , do share your thoughts with us.'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[700],
                    child: Icon(Icons.facebook),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue[700],
                    child: Icon(Icons.email),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue[700],
                    child: Icon(Icons.discord),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("facebook"),
                  Text("Email"),
                  Text("Discord")
                ],
              ),
             Padding(
               padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
               child: DropdownButtonFormField(
                hint: Text("Feedback"),
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                items: [
                  'Feedback',
                  'Complaints',
                  "Suggetions (Features / Fix bugs)"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  
                },
              ),
             ),
             Padding(
               padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
               child: TextFormField(maxLines: 5,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          label: Text("Your Feedback",style: TextStyle(color: Colors.black),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                      ),
             ),
             Padding(
               padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
               child: FutureBuilder(
                future: getUserDetails(myuid),
                builder: (context, AsyncSnapshot<UserModel> snapshot) {
                  if(snapshot.hasData) {
                    return TextFormField(
                    enabled: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            label: Text(snapshot.data!.email,style: TextStyle(color: Colors.black),),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
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
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Center(
                 child: MaterialButton(
                  color: Colors.blue[100],
                  child: Text('Send Feedback'),
                  onPressed: () {
                   
                 },),
               ),
             )
            ],
          ),
        ),
    );
  }
}
