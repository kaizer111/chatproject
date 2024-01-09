import 'package:chattingapp/Constants/databseConstants.dart';
import 'package:chattingapp/model/chat_room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


createChatroom(String otheruserid)async {
  String myuid= FirebaseAuth.instance.currentUser!.uid;
  String chatroomid = await generateChatRoomId(otheruserid);
  try {
    ChatRoomModel chatRoomModel = ChatRoomModel( lastchattime: DateTime.now(), chatroomid: chatroomid, users: [myuid,otheruserid]);
    await chatroomdb.doc(chatroomid).set(chatRoomModel.toJson());
    // 2 cases

    final friendsResponse = await friendsDb.doc(myuid).get();

    // Case 1 : Existing friends
    if(friendsResponse.exists){
      List<dynamic> existingFriends = friendsResponse.data()!['friends']; // fetching list of existing friends
      if(!existingFriends.contains(otheruserid)){
        existingFriends.add(otheruserid); // updating the existing list by adding new friend
      }
      await friendsDb.doc(myuid).update({'friends':existingFriends}); // updating the list in the server
    }
    // Case 2 :  No friends
    else{
      List<dynamic> friendList = [];
      friendList.add(otheruserid);
      await friendsDb.doc(myuid).set({'friends':friendList});
    }
    
  } catch (e) {
    print(e.toString());
  }
}


generateChatRoomId (String otheruserid) async{
  String myuid=FirebaseAuth.instance.currentUser!.uid;
  if(otheruserid!=myuid){
     String myuid=FirebaseAuth.instance.currentUser!.uid;
  String chatroomid = (myuid.compareTo(otheruserid)<0)?(myuid+otheruserid):(otheruserid+myuid);
  return chatroomid;
  }
  else{
    return;
  }
}

 getChatRooms(){
  String myuid=FirebaseAuth.instance.currentUser!.uid;
  return chatroomdb.where('users',arrayContains: myuid).orderBy('lastchattime',descending: true).snapshots();
}

