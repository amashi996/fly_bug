import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import pages
import '../constants/constants.dart';
import 'homepage.dart';
import 'package:fly_bug/pages/profile.dart';

class NavigationalPage extends StatefulWidget {
  NavigationalPage({Key? key}) : super(key: key);

  @override
  _NavigationalPageState createState() => _NavigationalPageState();
}

class _NavigationalPageState extends State<NavigationalPage> {
  int currentTabIndex = 0;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  List<Widget> tabs = [HomePage(), ProfilePage()];

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  //Bottom Navigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp), label: 'Profile'),
        ],
      ),
    );
  }
}
