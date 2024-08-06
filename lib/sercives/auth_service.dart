import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp(String email, String password, String name, int age, String phone, String gender) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': user.email,
          'age': age,
          'phone': phone,
          'gender': gender,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return user;
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
    }
    return null;
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}