import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fly_bug/pages/customizebutton.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:fly_bug/services/auth.dart';
import 'package:fly_bug/constants/constants.dart';
import 'package:fly_bug/pages/bottomnavigation.dart';
import 'package:fly_bug/pages/bottomnavigation.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pwdInputController = TextEditingController();

  void toast(String msg, Toast toast, ToastGravity toastGravity, Color colors) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: toastGravity,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  //Start email & password validation
  //Start email validation
  //check whether all the necessary points in email are included in user entered email/username
  String emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return ValidatorConstants.INVALID_EMAIL_FORMAT;
    } else {
      return '';
    }
  }
  //End email validation

  //Start Password validation
  String pwdValidator(String? value) {
    //check whether the number of characters in tha password less than 8
    if (value != null && value.length < 8) {
      return ValidatorConstants.WEAK_PASSWORD;
    } else {
      return '';
    }
  }
  //End password validation
  //End email & password validation

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        new ProgressDialog(context, type: ProgressDialogType.normal);
    progressDialog.style(
        message: ProgressDialogMesssageConstants.LOGGING_IN,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
        appBar: AppBar(
          title: Text(
            TitleConstants.LOGIN,
            textAlign: TextAlign.justify,
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_EMAIL,
                        hintText: HintTextConstants.HINT_EMAIL),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    //validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_PASSWORD,
                        hintText: HintTextConstants.HINT_PASSWORD),
                    controller: pwdInputController,
                    obscureText: true,
                    //validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context)
                            .primaryColor, //change the background color
                        minimumSize: const Size(100, 45),
                        onPrimary: Colors.white, //change the text color
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19))),
                    onPressed: () async {
                      if (_loginFormKey.currentState!.validate()) {
                        await progressDialog.show();
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                            .then((currentUser) => FirebaseFirestore.instance
                                .collection("users")
                                .doc(currentUser.user!.uid)
                                .get()
                                .then((DocumentSnapshot result) =>
                                    progressDialog.hide().then((isHidden) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NavigationalPage()));
                                    }).whenComplete(() {
                                      toast(
                                          ToastConstants.WELCOME,
                                          Toast.LENGTH_LONG,
                                          ToastGravity.BOTTOM,
                                          Colors.blueGrey);
                                    }))
                                .catchError((err) => print(err)))
                            .catchError((err) {
                          progressDialog.hide();
                          showAuthError(err.code, context);
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(ButtonConstants.LOGIN_BTN),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                  ),
                  Text(LabelConstants.LABEL_NEW_HERE),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context)
                            .primaryColor, //change the background color
                        minimumSize: const Size(100, 35),
                        onPrimary: Colors.white, //change the text color
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19))),
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text(ButtonConstants.REGISTER_BTN),
                  )
                ],
              ),
            ))));
  }

  void showAuthError(errorCode, BuildContext context) {
    switch (errorCode) {
      case FirebaseAuthErrorConstants.ERROR_WRONG_PASSWORD:
        toast(ToastConstants.INCORRECT_PASSWORD, Toast.LENGTH_LONG,
            ToastGravity.BOTTOM, Colors.blueGrey);
        break;

      default:
        toast(ToastConstants.UNKNOWN_AUTH_ERROR, Toast.LENGTH_LONG,
            ToastGravity.BOTTOM, Colors.blueGrey);
        break;
    }
  }
}
