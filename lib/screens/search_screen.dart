import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cour_app/screens/post_screen.dart';
import 'package:cour_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../reusable_widgets/reusable_widget.dart';
import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _search_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Поиск", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            reusableTextField(
                "Введите логин", Icons.search, false, _search_controller),
            firebaseUIButton(context, "Поиск", () {}),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("user_name", isEqualTo: _search_controller.text)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Загрузка");
                  }
                  final users = snapshot.requireData.size == 0
                      ? null
                      : snapshot.requireData.docs[0].get("user_name");
                  if (users == null) {
                    return const Text(
                      "Пользователь не найден",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                    );
                  } else {
                    return Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: InkWell(
                          child: ListTile(
                            title: Text(
                              users,
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.black),
                            ),
                            leading: const Icon(
                              Icons.face,
                              size: 50,
                              color: Colors.black,
                            ),
                            trailing: const Icon(Icons.arrow_forward, size: 30, color: Colors.black,),

                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(index: snapshot.requireData.docs[0]["userId"])));
                          },
                        ),
                        color: Colors.grey,
                        elevation: 3,
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
        color: Colors.black,
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
            padding: const EdgeInsets.all(16),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
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
