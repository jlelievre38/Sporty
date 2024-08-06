import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sporty App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SignInScreen(),
      debugShowCheckedModeBanner: false, // Supprime le bandeau "debug"
    );
  }
}