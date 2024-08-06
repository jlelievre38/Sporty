import 'package:flutter/material.dart';
import 'dart:math';

/// Dessine un arc de cercle représentant le progrès
class ArcPainter extends CustomPainter {
  final int steps;
  final int dailyStepGoal;

  ArcPainter({required this.steps, required this.dailyStepGoal});

  @override
  void paint(Canvas canvas, Size size) {
    double progress = (steps / dailyStepGoal).clamp(0.0, 1.0);
    double angle = 180 * progress; // Angle de l'arc basé sur les pas

    Paint trackPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.greenAccent, Colors.greenAccent],
      ).createShader(Rect.fromCircle(center: Offset(size.width / 2, size.height), radius: size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // Dessine l'arrière-plan de l'arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height), radius: size.height),
      pi, // Point de départ de l'arc
      pi, // Angle total (demi-cercle)
      false,
      trackPaint,
    );

    // Dessine l'arc de progression
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height), radius: size.height),
      pi, // Point de départ de l'arc
      angle * (pi / 180), // Convertit l'angle en radians
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}