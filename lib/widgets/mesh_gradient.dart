import 'dart:math';
import 'package:flutter/material.dart';

class MeshGradientAnimation extends StatefulWidget {
  final List<Color> colors;
  const MeshGradientAnimation({super.key, required this.colors});

  @override
  State<MeshGradientAnimation> createState() => _MeshGradientAnimationState();
}

class _MeshGradientAnimationState extends State<MeshGradientAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
          painter: _MeshPainter(
            animationValue: _controller.value,
            colors: widget.colors,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _MeshPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  _MeshPainter({required this.animationValue, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Draw base background using first color
    final basePaint = Paint()..color = colors[0];
    canvas.drawRect(rect, basePaint);

    for (int i = 0; i < colors.length; i++) {
      final t = (animationValue + (i / colors.length)) % 1.0;
      final angle = t * 2 * pi;
      
      // Calculate oscillating centers for the mesh blobs
      final radiusX = size.width * 0.3;
      final radiusY = size.height * 0.3;
      
      final centerX = size.width / 2 + cos(angle + i * 1.5) * radiusX;
      final centerY = size.height / 2 + sin(angle * 1.2 + i * 0.8) * radiusY;

      final blobPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i].withValues(alpha: 0.6),
            colors[i].withValues(alpha: 0.0),
          ],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: size.width * 0.7));

      canvas.drawCircle(Offset(centerX, centerY), size.width * 0.7, blobPaint);
    }
  }

  @override
  bool shouldRepaint(_MeshPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
