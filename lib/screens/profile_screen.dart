import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final User? user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    // Récupère l'ID de l'utilisateur actuel
    String userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          // Gestion des états de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Gestion des erreurs
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          // Vérifie si les données existent
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Aucune donnée trouvée'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                SizedBox(height: 16),
                Text("Nom: ${userData['name'] ?? 'Inconnu'}", style: TextStyle(fontSize: 18)),
                Text("Email: ${userData['email'] ?? 'Inconnu'}", style: TextStyle(fontSize: 18)),
                Text("Numéro de téléphone: ${userData['phone'] ?? 'Inconnu'}", style: TextStyle(fontSize: 18)),
                Text("Âge: ${userData['age'] ?? 'Inconnu'}", style: TextStyle(fontSize: 18)),
                Text("Sexe: ${userData['gender'] ?? 'Inconnu'}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Retour"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}