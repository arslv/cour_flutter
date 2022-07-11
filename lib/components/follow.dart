import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<bool> followCheck(userId) async {
  var follows = await FirebaseFirestore.instance
      .collection("Subs")
      .where("user",
          isEqualTo: FirebaseAuth.instance.currentUser?.uid.toString())
      .get() ;

  if (follows.docs[0].get("followers").toList().contains(userId)) {
    return true;
  } else {
    return false;
  }
}

void follow(String followerId) async {
  var follows = await FirebaseFirestore.instance
      .collection("Subs")
      .where("user",
          isEqualTo: FirebaseAuth.instance.currentUser?.uid.toString())
      .get();

  if (follows.size != 0 && await followCheck(followerId)) {
    var followersi = [...follows.docs[0].get("followers")];
    followersi.remove(followerId);
    await FirebaseFirestore.instance
        .collection("Subs")
        .doc(follows.docs[0].id)
        .update({
      "followers": FieldValue.arrayRemove([followerId])
    });
    print(await followCheck(followerId));
  } else {  if (follows.size == 0) {
    await FirebaseFirestore.instance.collection("Subs").add({
      "user": FirebaseAuth.instance.currentUser?.uid.toString(),
      "followers": [followerId]
    });
  } else {
    var followers = [...follows.docs[0].get("followers"), followerId];
    await FirebaseFirestore.instance
        .collection("Subs")
        .doc(follows.docs[0].id)
        .update({"followers": followers.toSet().toList()});
  }}

}
