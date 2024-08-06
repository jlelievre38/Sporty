import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/sign_in_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscription et Connexion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Vérifie si l'utilisateur est connecté
    if (user != null) {
      return HomeScreen(); // Affiche l'écran d'accueil s'il est connecté
    } else {
      return SignInScreen(); // Affiche l'écran de connexion s'il ne l'est pas
    }
  }
}