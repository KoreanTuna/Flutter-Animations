import 'package:flutter/material.dart';

class BubbleFab extends StatefulWidget {
  const BubbleFab({super.key});

  @override
  State<BubbleFab> createState() => _BubbleFabState();
}

class _BubbleFabState extends State<BubbleFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeFactor;
  late Animation<BorderRadius?> _borderRadiusAnimation;

  final double fabSize = 56.0;
  final Duration duration = const Duration(milliseconds: 360);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);

    _sizeFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _borderRadiusAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize / 2),
      end: BorderRadius.circular(0),
    ).animate(_sizeFactor);
  }

  void _onTap() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxSize = screenSize.height;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double size = fabSize + (maxSize - fabSize) * _sizeFactor.value;

        return GestureDetector(
          onTap: _onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: _borderRadiusAnimation.value,
            ),
            alignment: Alignment.center,
            child: _controller.status == AnimationStatus.completed
                ? const _CompleteView()
                : const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}

class _CompleteView extends StatefulWidget {
  const _CompleteView({super.key});

  @override
  State<_CompleteView> createState() => _CompleteViewState();
}

class _CompleteViewState extends State<_CompleteView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bubblePopController;
  late final Animation<double> _bubblePopAnimation;

  @override
  void initState() {
    super.initState();
    _bubblePopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _bubblePopAnimation = CurvedAnimation(
      parent: _bubblePopController,
      curve: Curves.elasticInOut,
    );
    _bubblePopController.forward();
  }

  @override
  void dispose() {
    _bubblePopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// _bubblePopController에 맞춰서 버튼들이 가운데에서 양옆으로 커지면서 노출될 수 있도록 애니메이션 제작
        AnimatedBuilder(
          animation: _bubblePopAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.1 + _bubblePopAnimation.value * 1,
              child: child,
            );
          },
          child: Column(
            children: [
              Container(
                width: 240,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text(
                    '버튼 딱!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
