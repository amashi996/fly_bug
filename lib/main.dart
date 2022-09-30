import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fly_bug/pages/bottomnavigation.dart';
import 'package:fly_bug/pages/homepage.dart';
import 'package:fly_bug/pages/login.dart';
import 'package:fly_bug/pages/register.dart';
import 'package:fly_bug/pages/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? LoginPage()
          : NavigationalPage(),
      routes: <String, WidgetBuilder>{
        '/home': (_) => const HomePage(),
        '/register': (_) => RegisterPage(),
        '/login': (_) => LoginPage()
      },
    );
  }
}
