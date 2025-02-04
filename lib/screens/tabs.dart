import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p8/screens/add_post.dart';
import 'package:p8/screens/auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:p8/screens/contacts_screen.dart';
import 'package:p8/screens/home.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;
  String username = "Loading...";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future<void> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        username = userDoc['username'] ?? "No Name";
        imageUrl = userDoc['image_url'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen;
    String activeTitle;

    if (_selectedPageIndex == 0) {
      activeScreen = const PlacesScreen();
      activeTitle = 'HOME ';
    } else if (_selectedPageIndex == 1) {
      activeScreen = const AddPlaceScreen();
      activeTitle = 'NEW  POST ';
    } else {
      activeScreen = const ContactsScreen();
      activeTitle = 'CONTACTS';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(220, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          activeTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: activeScreen,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: Color.fromRGBO(18, 33, 58, 1),
        buttonBackgroundColor: Color.fromRGBO(38, 78, 131, 0.624),
        animationDuration: Duration(milliseconds: 300), // Smooth animation
        height: 75, // Adjust height if needed
        index: _selectedPageIndex, // Ensure it updates the selected index
        onTap: _selectedPage, // Handle page changes
        items: const [
          Icon(Icons.home_filled, size: 30, color: Colors.white),
          Icon(Icons.add, size: 30, color: Colors.white),
          Icon(Icons.people, size: 30, color: Colors.white),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color.fromRGBO(12, 27, 47, 0.87),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                    child: imageUrl.isEmpty
                        ? const Icon(Icons.person,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                size: 21,
                Icons.person,
                color: Colors.white,
              ),
              title: const Text(
                '    Account',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                size: 21,
                Icons.notifications,
                color: Colors.white,
              ),
              title: const Text(
                '    Notifications',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.question_mark_sharp,
                size: 21,
                color: Colors.white,
              ),
              title: const Text(
                '     Help',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onTap: () {},
            ),
            SizedBox(
              height: 453,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              title: const Text(
                '          Log out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                setState(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => AuthenticationScreen(),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
