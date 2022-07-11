import 'package:cour_app/screens/home_screen.dart';
import 'package:cour_app/screens/profile_screen.dart';
import 'package:cour_app/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../models/posts.dart';
import '../reusable_widgets/reusable_widget.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final TextEditingController _postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Написать"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(top:10),
          child: Column(
            children: [reusableTextField("Введите текст", Icons.create, false, _postTextController),
            firebaseUIButton(context, "Отправить", () {
              addPost(_postTextController.text);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            }),],
          ),
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
    );
  }
}
