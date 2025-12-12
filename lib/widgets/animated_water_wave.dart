import 'package:flutter/material.dart';
import 'package:aquatrack/widgets/water_wave_painter.dart';
import 'package:aquatrack/core/theme/app_colors.dart';

class AnimatedWaterWave extends StatefulWidget {
  final double fillPercentage;
  final double width;
  final double height;
  final Color? waveColor;
  final Color? backgroundColor;

  const AnimatedWaterWave({
    super.key,
    required this.fillPercentage,
    this.width = 200,
    this.height = 200,
    this.waveColor,
    this.backgroundColor,
  });

  @override
  State<AnimatedWaterWave> createState() => _AnimatedWaterWaveState();
}

class _AnimatedWaterWaveState extends State<AnimatedWaterWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: WaterWavePainter(
            animationValue: _controller.value,
            fillPercentage: widget.fillPercentage.clamp(0.0, 1.0),
            waveColor: widget.waveColor ?? AppColors.primary,
            backgroundColor:
                widget.backgroundColor ?? AppColors.progressEmpty,
          ),
        );
      },
    );
  }
}

