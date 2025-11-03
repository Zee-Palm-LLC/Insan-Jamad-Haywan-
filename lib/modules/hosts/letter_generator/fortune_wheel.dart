import 'dart:math';

import 'package:flutter/material.dart';

class AlphabetFortuneWheel extends StatefulWidget {
  final double size;
  final Function(String letter)? onSpinComplete;

  const AlphabetFortuneWheel({
    super.key,
    this.size = 350,
    this.onSpinComplete,
  });

  @override
  State<AlphabetFortuneWheel> createState() => _AlphabetFortuneWheelState();
}

class _AlphabetFortuneWheelState extends State<AlphabetFortuneWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentAngle = 0.0;
  bool _isSpinning = false;

  final List<Color> colors = const [
    Color(0xFFFCF0DA),
    Color(0xFFBED6E2),
    Color(0xFF449F50),
    Color(0xFFF66F6C),
    Color(0xFFFFD767),
  ];

  final List<String> alphabets =
      List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isSpinning = false);
        final selectedLetter = _getSelectedLetter();
        widget.onSpinComplete?.call(selectedLetter);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void spin() {
    if (_isSpinning) return;

    setState(() => _isSpinning = true);
    final random = Random();
    final spins = 5 + random.nextInt(3); // random full spins
    final endAngle = _currentAngle + (2 * pi * spins) + random.nextDouble() * 2 * pi;

    final tween = Tween<double>(begin: _currentAngle, end: endAngle);
    _animation = tween.animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));

    _controller
      ..reset()
      ..forward();

    _animation.addListener(() {
      setState(() {
        _currentAngle = _animation.value;
      });
    });
  }

  String _getSelectedLetter() {
    final normalized = (_currentAngle % (2 * pi));
    final anglePerSegment = 2 * pi / alphabets.length;
    final index = (alphabets.length - (normalized ~/ anglePerSegment) - 1) %
        alphabets.length;
    return alphabets[index];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _AlphabetWheelPainter(
            alphabets: alphabets,
            colors: colors,
            rotation: _currentAngle,
          ),
        ),
        Positioned(
          top: widget.size * 0.05,
          child: Icon(
            Icons.arrow_drop_down,
            size: 40,
            color: Colors.black,
          ),
        ),
        Positioned(
          bottom: 10,
          child: ElevatedButton(
            onPressed: _isSpinning ? null : spin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _isSpinning ? "Spinning..." : "Start!",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Kalam',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AlphabetWheelPainter extends CustomPainter {
  final List<String> alphabets;
  final List<Color> colors;
  final double rotation;

  _AlphabetWheelPainter({
    required this.alphabets,
    required this.colors,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final anglePerSegment = 2 * pi / alphabets.length;

    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (int i = 0; i < alphabets.length; i++) {
      paint.color = colors[i % colors.length];
      final startAngle = i * anglePerSegment;

      // draw slice
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        startAngle,
        anglePerSegment,
        true,
        paint,
      );

      // draw text
      final textSpan = TextSpan(
        text: alphabets[i],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kalam',
        ),
      );
      textPainter.text = textSpan;
      textPainter.layout();

      final angle = startAngle + anglePerSegment / 2;
      final offset = Offset(
        cos(angle) * radius * 0.65 - textPainter.width / 2,
        sin(angle) * radius * 0.65 - textPainter.height / 2,
      );

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AlphabetWheelPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
