import 'package:flutter/material.dart';
import 'package:aquatrack/core/theme/app_colors.dart';
import 'dart:math' as math;

class CircularWaterProgress extends StatefulWidget {
  final double progress;
  final double size;
  final int currentMl;
  final int goalMl;

  const CircularWaterProgress({
    super.key,
    required this.progress,
    required this.size,
    required this.currentMl,
    required this.goalMl,
  });

  @override
  State<CircularWaterProgress> createState() => _CircularWaterProgressState();
}

class _CircularWaterProgressState extends State<CircularWaterProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.progress * 100).clamp(0, 150).toInt();
    final isOverGoal = widget.progress > 1.0;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer circle
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),

          // Water fill with wave animation
          ClipOval(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _CircularWavePainter(
                    progress: widget.progress.clamp(0.0, 1.0),
                    wavePhase: _waveController.value,
                    color: isOverGoal
                        ? AppColors.progressExceeded
                        : AppColors.progressFilled,
                  ),
                );
              },
            ),
          ),

          // Progress ring
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: widget.progress.clamp(0.0, 1.0),
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverGoal ? AppColors.progressExceeded : AppColors.primary,
              ),
            ),
          ),

          // Text content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: widget.size * 0.15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.currentMl}ml',
                style: TextStyle(
                  fontSize: widget.size * 0.08,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'of ${widget.goalMl}ml',
                style: TextStyle(
                  fontSize: widget.size * 0.06,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularWavePainter extends CustomPainter {
  final double progress;
  final double wavePhase;
  final Color color;

  _CircularWavePainter({
    required this.progress,
    required this.wavePhase,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Calculate water level
    final waterLevel = size.height * (1 - progress);

    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from left edge at water level
    path.moveTo(0, waterLevel);

    // Draw wave
    for (double x = 0; x <= size.width; x++) {
      final normalizedX = x / size.width;
      final y = waterLevel +
          math.sin((normalizedX * 4 * math.pi) + (wavePhase * 2 * math.pi)) *
              (size.height * 0.02);
      path.lineTo(x, y);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Clip to circle
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    canvas.drawPath(path, paint);

    // Draw second wave
    final paint2 = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, waterLevel);

    for (double x = 0; x <= size.width; x++) {
      final normalizedX = x / size.width;
      final y = waterLevel +
          math.sin((normalizedX * 4 * math.pi) -
                  (wavePhase * 2 * math.pi) +
                  math.pi / 2) *
              (size.height * 0.015);
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_CircularWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.wavePhase != wavePhase;
  }
}

