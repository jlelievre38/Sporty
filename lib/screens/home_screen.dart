import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_screen.dart';
import 'profile_screen.dart'; // Assure-toi que le chemin est correct

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileScreen(user: user),
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SignInScreen(),
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Bienvenue !"),
      ),
    );
  }
}