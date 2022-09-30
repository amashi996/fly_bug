import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fly_bug/services/auth.dart';
import 'package:fly_bug/constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  String userId = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //create a function for the toast
  void toast(String msg, Toast toast, ToastGravity toastGravity, Color colors) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: toastGravity,
        timeInSecForIosWeb: 1,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  /*void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          userId = user?.uid;
        }
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(TitleConstants.PROFILE),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(TitleConstants.ALERT_SIGN_OUT),
                        content:
                            Text(PromptConstants.QUESTION_CONFIRM_SIGN_OUT),
                        actions: [
                          TextButton(
                            child: Text(ButtonConstants.OPTION_CANCEL),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(ButtonConstants.OPTION_YES),
                            onPressed: () {
                              firebaseAuth.signOut();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/login", (_) => false);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        body: _prepareDetailAndBody(context, userId));
  }

  Widget _prepareDetailAndBody(BuildContext context, String userId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return _movieDetailBody(context, snapshot.data);
      },
    );
  }

  Widget _movieDetailBody(BuildContext context, DocumentSnapshot snapshot) {
    final rating = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        snapshot["email"],
        style: TextStyle(color: Colors.white),
      ),
    );

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Text(
          snapshot["fname"] + " " + snapshot["surname"],
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
        SizedBox(height: 20.0),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Expanded(child: rating)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
        )
      ],
    );

    final headerContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new NetworkImage(NetworkImagesPath.PROFILE_AVATAR),
                  fit: BoxFit.cover),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(54, 60, 100, .9)),
          child: Center(
            child: header,
          ),
        ),
      ],
    );

    final editProfileButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton.icon(
          icon: Icon(Icons.edit, color: Colors.white),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
            onPrimary: Theme.of(context).primaryColor,
          ),
          onPressed: () => {_displayDialog(context, snapshot)},
          label: Text(ButtonConstants.EDIT_PROFILE,
              style: TextStyle(color: Colors.white)),
        ));

    final deleteAccountButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton.icon(
          icon: Icon(Icons.delete, color: Colors.white),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19)),
              onPrimary: Colors.red),
          onPressed: () => {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(TitleConstants.ALERT_WARNING),
                    content:
                        Text(PromptConstants.QUESTION_CONFIRM_ACCOUNT_DELETE),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(ButtonConstants.OPTION_CANCEL),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          final FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          final FirebaseAuth firebaseAuth =
                              FirebaseAuth.instance;

                          db
                              .collection('users')
                              .doc(firebaseAuth.currentUser!.uid)
                              .get()
                              .then((value) => {});

                          toast(
                              ToastConstants.PROFILE_DELETED_SUCCESS,
                              Toast.LENGTH_LONG,
                              ToastGravity.BOTTOM,
                              Colors.blueGrey);
                        },
                        child: Text(ButtonConstants.OPTION_DELETE),
                      ),
                    ],
                  );
                })
          },
          label: Text(ButtonConstants.DELETE_PROFILE,
              style: TextStyle(color: Colors.white)),
        ));

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: <Widget>[editProfileButton, deleteAccountButton],
        ),
      ),
    );

    return new Scaffold(
      body: Column(
        children: <Widget>[headerContent, bottomContent],
      ),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  _displayDialog(BuildContext context, DocumentSnapshot snapshot) async {
    TextEditingController fnameController = new TextEditingController();
    TextEditingController surnameConroller = new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(TitleConstants.ALERT_EDIT_PROFILE),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            content: Container(
              height: 100,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: fnameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: snapshot["fname"]),
                    ),
                    TextField(
                      controller: surnameConroller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: snapshot["surname"]),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(ButtonConstants.OPTION_CANCEL),
              ),
              TextButton(
                onPressed: () {
                  //return false;

                  String fname = "";
                  String surname = "";

                  if (fnameController.text.isEmpty)
                    fname = snapshot["fname"];
                  else
                    fname = fnameController.text;

                  if (surnameConroller.text.isEmpty)
                    surname = snapshot["surname"];
                  else
                    surname = surnameConroller.text;

                  //print(widget.uid);

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(firebaseAuth.currentUser!.uid)
                      .set({
                    "fname": fname,
                    "surname": surname,
                    "email": snapshot["email"],
                    "uid": firebaseAuth.currentUser!.uid
                  });
                  Navigator.of(context).pop();
                  toast(ToastConstants.PROFILE_UPDATE_SUCCESS,
                      Toast.LENGTH_LONG, ToastGravity.BOTTOM, Colors.blueGrey);
                },
                child: Text(ButtonConstants.OPTION_UPDATE),
              ),
            ],
          );
        });
  }
}
