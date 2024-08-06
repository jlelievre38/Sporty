import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'arc_painter.dart'; // Assurez-vous d'importer votre arc painter

class PedometerScreen extends StatefulWidget {
  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  int _steps = 100; // Commencer à 100 pas
  String _status = "Unknown";
  static const int dailyStepGoal = 10000; // Nombre de pas conseillé par jour

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
      _stepCountStream = await Pedometer.stepCountStream;

      _stepCountStream.listen(onStepCount).onError(onStepCountError);
      _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);
    } catch (e) {
      print("Erreur d'initialisation du podomètre: $e");
    }
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps + 100; // Ajouter 100 aux pas
    });
    print("Nombre de pas: $_steps");
    _saveStepsToFirestore();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onStepCountError(error) {
    print("Erreur de comptage des pas: $error");
  }

  void onPedestrianStatusError(error) {
    print("Erreur de statut piéton: $error");
  }

  Future<void> _saveStepsToFirestore() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DateTime now = DateTime.now();
      String dateKey = "${now.year}-${now.month}-${now.day}";

      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

      try {
        // Enregistrement du nombre de pas dans le document utilisateur
        await userDoc.update({
          'steps': FieldValue.arrayUnion([
            {'date': now, 'steps': _steps}
          ]),
        });
        print("Pas enregistrés avec succès pour la date : $dateKey");
      } catch (e) {
        print("Erreur lors de l'enregistrement des pas : $e");
      }
    } else {
      print("Utilisateur non authentifié.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Podomètre"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 150, // Ajuste la hauteur pour former un demi-cercle
              child: CustomPaint(
                painter: ArcPainter(
                  steps: _steps,
                  dailyStepGoal: dailyStepGoal,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nombre de pas:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_steps',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Statut piéton:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              _status,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _steps = 100; // Réinitialiser le compteur de pas à 100 si nécessaire
                });
              },
              child: Text("Réinitialiser"),
            ),
          ],
        ),
      ),
    );
  }
}