import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyBoard extends StatelessWidget {
  const MoneyBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: MoneyAnimation(
          startValue: 0,
          endValue: 1000000,
        ),
      ),
    );
  }
}

class MoneyAnimation extends StatefulWidget {
  final int startValue;
  final int endValue;
  const MoneyAnimation({
    super.key,
    this.startValue = 0,
    this.endValue = 350000,
  });

  @override
  State<MoneyAnimation> createState() => _MoneyAnimationState();
}

class _MoneyAnimationState extends State<MoneyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _glitchTimer;
  bool _showGlitch = false;

  final duration = const Duration(milliseconds: 4500); // 빠르게 올라감
  final numberFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: duration);
    _animation =
        Tween<double>(
            begin: widget.startValue.toDouble(),
            end: widget.endValue.toDouble(),
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _startGlitchLoop();
            }
          });

    _controller.forward();
  }

  void _startGlitchLoop() {
    _showGlitch = true;

    _glitchTimer = Timer.periodic(
      Duration(milliseconds: 500),
      (_) {
        setState(() => _showGlitch = true);
        Future.delayed(Duration(milliseconds: 140 * Random().nextInt(4)), () {
          if (mounted) {
            setState(() => _showGlitch = false);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _glitchTimer?.cancel();
    super.dispose();
  }

  List<Color> _getMotionBlurColors(double opacity) {
    return [
      Colors.greenAccent.withValues(alpha: opacity),
      Colors.cyanAccent.withValues(alpha: opacity),
      Colors.limeAccent.withValues(alpha: opacity),
      Colors.redAccent.withValues(alpha: opacity),
    ];
  }

  Widget _buildBlurredNumber(double value) {
    final formatted = numberFormat.format(value.floor());

    return Stack(
      alignment: Alignment.center,
      children: [
        if (!_animation.isCompleted)
          ...List.generate(4, (i) {
            final offset = (4 - i) * 200;
            final num = max(widget.startValue, value.floor() - offset);
            final opacity = (1 - i * 0.1).clamp(0.0, 1.0);
            return Opacity(
              opacity: opacity,
              child: Text(
                numberFormat.format(num),
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: _getMotionBlurColors(opacity)[i % 4],
                ),
              ),
            );
          }),

        // 메인 숫자 표시 (글리치 효과 적용)
        if (_showGlitch)
          _GlitchText(text: formatted)
        else
          Text(
            formatted,
            style: const TextStyle(
              fontSize: 66,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _buildBlurredNumber(_animation.value),
      ),
    );
  }
}

class _GlitchText extends StatefulWidget {
  final String text;
  const _GlitchText({super.key, required this.text});

  @override
  State<_GlitchText> createState() => __GlitchTextState();
}

class __GlitchTextState extends State<_GlitchText>
    with SingleTickerProviderStateMixin {
  late AnimationController _glitchController;
  late Animation<double> _glitchAnimation;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _glitchAnimation =
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _glitchController,
            curve: Curves.bounceInOut,
          ),
        )..addListener(() {
          setState(() {});
        });

    _startGlitch();
  }

  @override
  void dispose() {
    _glitchController.dispose();
    super.dispose();
  }

  void _startGlitch() {
    _glitchController.reset();
    _glitchController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glitchAnimation,
      builder: (context, child) {
        final offset =
            2.2 * Random().nextDouble() * (Random().nextBool() ? 1 : -1);
        return Transform.translate(
          offset: Offset(offset, offset),
          child: _buildGlitchText(widget.text),
        );
      },
    );
  }

  Widget _buildGlitchText(String text) {
    // 3겹의 같은 텍스트를 Offset 다르게 겹치기

    final double randomValue = 0.99 + 0.01 * Random().nextDouble();
    return Stack(
      children: [
        Positioned(
          left: -5 * Random().nextDouble(),
          top: 5 * Random().nextDouble(),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 66 * randomValue,
              letterSpacing: 1.2 * randomValue,

              fontWeight: FontWeight.bold,
              color: Colors.redAccent.withValues(alpha: 0.9),
            ),
          ),
        ),
        Positioned(
          right: 5 * Random().nextDouble(),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 66 * randomValue,
              letterSpacing: 1.2 * randomValue,

              fontWeight: FontWeight.bold,

              color: Colors.cyanAccent.withValues(alpha: 0.7),
            ),
          ),
        ),
        Positioned(
          bottom: 2 * Random().nextDouble(),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 66 * randomValue,
              letterSpacing: 1.2 * randomValue,

              fontWeight: FontWeight.bold,

              color: Colors.limeAccent.withValues(alpha: 0.5),
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 66 * randomValue,
            letterSpacing: 1.2 * randomValue,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
