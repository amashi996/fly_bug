import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    return firebaseAuth.signOut();
  }

  /*getCurrentUserUid() async {
    User user = await firebaseAuth.currentUser.uid();
    return user.uid;
  }

  Future<User> getCurrentUser() async {
    User user = await firebaseAuth.currentUser();
    return user;
  }*/
}
