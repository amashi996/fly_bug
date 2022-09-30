import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fly_bug/constants/constants.dart';
import 'bottomnavigation.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  /*initState() {
    FirebaseAuth.instance.currentUser!()
        .then((User currentUser) => {
              //if there is no current user logged into the app, then the system will redirect to login screen
              if (currentUser == null)
                Navigator.pushReplacementNamed(context, "/login")
              else
                {
                  //If there is an user already logged into the system, then redirect to home page
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser.toString())
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavigationalPage(
                                        title: TitleConstants.REGISTER,
                                        uid: '',
                                      ))))
                      .catchError((err) => print(err))
                }
            })
        .catchError((err) => print(err));
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(child: CircularProgressIndicator()),
      ),
    );
  }
}
