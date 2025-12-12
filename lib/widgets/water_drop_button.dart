import 'package:flutter/material.dart';
import 'package:aquatrack/core/theme/app_colors.dart';

class WaterDropButton extends StatefulWidget {
  final int amountMl;
  final VoidCallback onTap;
  final bool isSelected;

  const WaterDropButton({
    super.key,
    required this.amountMl,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<WaterDropButton> createState() => _WaterDropButtonState();
}

class _WaterDropButtonState extends State<WaterDropButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayAmount = widget.amountMl >= 1000
        ? '${(widget.amountMl / 1000).toStringAsFixed(1)}L'
        : '${widget.amountMl}ml';

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? AppColors.waterGradient
                : const LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : AppColors.divider,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? AppColors.primary.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop,
                size: 32,
                color: widget.isSelected
                    ? Colors.white
                    : AppColors.primary,
              ),
              const SizedBox(height: 8),
              Text(
                displayAmount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

