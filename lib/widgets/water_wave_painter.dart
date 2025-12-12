import 'dart:math';
import 'package:flutter/material.dart';

class WaterWavePainter extends CustomPainter {
  final double animationValue;
  final double fillPercentage;
  final Color waveColor;
  final Color backgroundColor;

  WaterWavePainter({
    required this.animationValue,
    required this.fillPercentage,
    required this.waveColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Calculate water level
    final waterLevel = size.height * (1 - fillPercentage);

    // Draw first wave
    final path1 = Path();
    path1.moveTo(0, waterLevel);

    for (double i = 0; i <= size.width; i++) {
      final y = waterLevel +
          sin((i / size.width * 2 * pi) + (animationValue * 2 * pi)) * 10;
      path1.lineTo(i, y);
    }

    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, paint);

    // Draw second wave with slight transparency
    final paint2 = Paint()
      ..color = waveColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, waterLevel);

    for (double i = 0; i <= size.width; i++) {
      final y = waterLevel +
          sin((i / size.width * 2 * pi) - (animationValue * 2 * pi) + pi / 2) *
              8;
      path2.lineTo(i, y);
    }

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(WaterWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.fillPercentage != fillPercentage;
  }
}

