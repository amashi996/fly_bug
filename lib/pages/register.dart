import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fly_bug/constants/constants.dart';
import 'package:fly_bug/pages/bottomnavigation.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pwdInputController = TextEditingController();
  TextEditingController confirmPwdInputController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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

  String pwdValidator(String? value) {
    if (value != null && value.length < 8) {
      return ValidatorConstants.WEAK_PASSWORD;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        new ProgressDialog(context, type: ProgressDialogType.normal);
    progressDialog.style(
        message: ProgressDialogMesssageConstants.WELCOME_ABOARD,
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
          title: Text(TitleConstants.REGISTER),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_FIRST_NAME,
                        hintText: HintTextConstants.HINT_FIRST_NAME),
                    controller: firstNameInputController,
                    validator: (value) {
                      if (value != null && value.length < 3) {
                        return ValidatorConstants.INVALID_FIRST_NAME;
                      }
                    },
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                          labelText: LabelConstants.LABEL_LAST_NAME,
                          hintText: HintTextConstants.HINT_LAST_NAME),
                      controller: lastNameInputController,
                      validator: (value) {
                        if (value != null && value.length < 3) {
                          return ValidatorConstants.INVALID_LAST_NAME;
                        }
                      }),
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
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_CONFIRM_PASSWORD,
                        hintText: HintTextConstants.HINT_PASSWORD),
                    controller: confirmPwdInputController,
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
                        minimumSize: const Size(100, 35),
                        onPrimary: Colors.white, //change the text color
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19))),
                    onPressed: () async {
                      if (_registerFormKey.currentState!.validate()) {
                        if (pwdInputController.text ==
                            confirmPwdInputController.text) {
                          await progressDialog.show();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .then((currentUser) => FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(firebaseAuth.currentUser!.uid)
                                  .set({
                                    "uid": firebaseAuth.currentUser!.uid,
                                    "fname": firstNameInputController.text,
                                    "surname": lastNameInputController.text,
                                    "email": emailInputController.text,
                                  })
                                  .then((result) => {
                                        progressDialog.hide().then((isHidden) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavigationalPage()),
                                              (_) => false);
                                        }),
                                        firstNameInputController.clear(),
                                        lastNameInputController.clear(),
                                        emailInputController.clear(),
                                        pwdInputController.clear(),
                                        confirmPwdInputController.clear()
                                      })
                                  .catchError((err) => print(err)))
                              .catchError((err) => print(err));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(TitleConstants.ALERT_ERROR),
                                  content: Text(ValidatorConstants
                                      .PASSWORDS_DO_NOT_MATCH),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(ButtonConstants.OPTION_CLOSE),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(ButtonConstants.REGISTER_BTN),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 130,
                  ),
                  Text(LabelConstants.LABEL_ALREADY_HAVE_ACCOUNT),
                  SizedBox(
                    height: 15,
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
                      Navigator.pop(context);
                    },
                    child: Text(ButtonConstants.LOGIN_BTN),
                  )
                ],
              ),
            ))));
  }
}
