import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cour_app/reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../components/like_button.dart';
import '../screens/profile_screen.dart';

late var name = '';

Future<void> addPost(dynamic variable1) async {
  FirebaseFirestore.instance.collection("Post").add({
    "user": FirebaseAuth.instance.currentUser?.uid,
    "email": FirebaseAuth.instance.currentUser?.email,
    "likes": 0,
    "text": variable1,
    "createdAt": DateTime.now().toString(),
    "user_name": await getName(FirebaseAuth.instance.currentUser!.uid)
  });
}

Future<String> getName(userId)async {
  var nameLink = FirebaseFirestore.instance
      .collection("Users")
      .where("userId", isEqualTo: userId).get();
  var name1 = await nameLink.then((value) => value.docs[0]["user_name"]);
  return name1;
}


Container cardPost(snapshot, index, context, userId) {
  return Container(
    decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey)
        ),
        color: Colors.black
    ),
    child: Card(
      color: Colors.black,
      child: ListTile(
        title: InkWell(
          child: Text(snapshot.docs[index]["user_name"],
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(index: snapshot.docs[index]["user"].toString())));},
        ),
        subtitle: Column(
          children: [
            Text(
              "${snapshot.docs[index]['text']}",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            Row(
              children: [
                InkWell(
                  child: const Icon(Icons.favorite_border, color: Colors.grey,),
                  onTap: () {
                    like(index);
                  },
                ),
                const SizedBox(width: 5),
                Text(
                  "${snapshot.docs[index]["likes"]}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        leading: const Icon(Icons.face, size: 30, color: Colors.white,),
      ),
    ),
  );
}

//void Add(String collection, String stroka, dynamic variable) {
//  CollectionReference coll = FirebaseFirestore.instance.collection(collection);
//  coll.add({stroka: variable});
//}

//void delete(String collection, int id){
//  var key = FirebaseFirestore.instance.collection(collection).get(id);
//  FirebaseFirestore.instance.collection(collection).doc(key).delete();
//}
