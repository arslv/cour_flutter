import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cour_app/models/posts.dart';
import 'package:cour_app/screens/post_screen.dart';
import 'package:cour_app/screens/search_screen.dart';
import 'package:cour_app/screens/singin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../models/posts.dart';

import '../components/follow.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String index;

  const ProfileScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId = "";
  late var name = '';
  late bool isFollowed = false;
  late bool _myProfile = false;

  @override
  void initState() {
    userId = widget.index;
    getName(userId).then((value) => setState(() {
          name = value;
        }));
    followCheck(userId).then((value) => setState(() {
          isFollowed = value;
        }));
    userId == FirebaseAuth.instance.currentUser?.uid
        ? _myProfile = true
        : _myProfile = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(),
                  const Icon(Icons.face, size: 50),
                  Container(
                    width: 200,
                    child: Text(name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        )),
                  ),
                  _myProfile
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.grey;
                                    }
                                    return Colors.black;
                                  }),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)))),
                              onPressed: () {
                                follow((userId));
                                followCheck(userId)
                                    .then((value) => setState(() {
                                          isFollowed = value;
                                        }));
                              },
                              child: isFollowed
                                  ? const Text("Отписаться")
                                  : const Text("Подписаться")),
                        ),
                  _myProfile
                      ? Padding(
                          padding: const EdgeInsets.only(left: 70),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.grey;
                                  }
                                  return Colors.black;
                                }),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)))),
                            child: const Text("Выйти"),
                            onPressed: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen()));
                              });
                            },
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              color: Colors.black,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: Colors.black,
                    child: _myProfile
                        ? const Text("Мои записи",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.grey))
                        : const Text("Записи",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.grey)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 491.8,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Post")
                          .where('user', isEqualTo: userId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Загрузка");
                        }

                        final data = snapshot.requireData;

                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return cardPost(data, index, context, userId);
                          },
                          physics: const BouncingScrollPhysics(),
                          itemCount: data.size,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.search,
                text: "Search",
              ),
              GButton(icon: Icons.account_circle, text: "Profile"),
              GButton(
                icon: Icons.create,
                text: "Write",
              ),
            ],
            onTabChange: (index) {
              switch (index) {
                case 0:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                  break;
                case 1:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                  break;
                case 2:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              index: FirebaseAuth.instance.currentUser!.uid
                                  .toString())));
                  break;
                case 3:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PostScreen()));
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
