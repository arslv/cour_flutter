
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void like(index) async{
  var whichLike = await FirebaseFirestore.instance
      .collection("Post").get();
  var nextLike = whichLike.docs[index].get("likes") + 1;

  FirebaseFirestore.instance.collection("Post").doc(whichLike.docs[index].id).update({"likes" : nextLike});
}