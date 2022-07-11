import 'package:cour_app/screens/post_screen.dart';
import 'package:cour_app/screens/profile_screen.dart';
import 'package:cour_app/screens/search_screen.dart';
import 'package:cour_app/screens/singin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cour_app/models/posts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../components/follow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:
          Container(
            height: 606,
            color: Colors.black,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Subs")
                  .where("user",
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid.toString())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Загрузка");
                }
                final followers = snapshot.requireData.size == 0 ? null : snapshot
                    .requireData.docs[0].get("followers");
                if (followers.length == 0) {
                  return const Text("Вы ни на кого не подписаны");
                } else {return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Post").where(
                      "user", whereIn: followers).snapshots()
                  , builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Загрузка");
                  }

                  final data = snapshot.requireData;

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return cardPost(data, index, context, name);
                    },
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.size,
                  );
                },); }
              },
            ),
          ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            padding: EdgeInsets.all(16),
            tabs: const[
              GButton(icon: Icons.home, text: "Home",),
              GButton(icon: Icons.search, text: "Search",),
              GButton(icon: Icons.account_circle, text: "Profile"),
              GButton(icon: Icons.create, text: "Write",),
            ],
            onTabChange: (index){
              switch (index) {
                case 0:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  break;
                case 1:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                  break;
                case 2:
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(index:FirebaseAuth.instance.currentUser!.uid.toString())));
                  break;
                case 3:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen()));
                  break;
              }
            },
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const PostScreen()));
      //   },
      //   child: const Icon(Icons.border_color),
      //   backgroundColor: Colors.blueAccent,
      // ),
    );
  }
}
