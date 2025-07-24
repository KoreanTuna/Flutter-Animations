import 'package:flutter/material.dart';

class BubbleSize extends StatelessWidget {
  const BubbleSize({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: [
                    CircleWidget(color: Colors.green),
                    CircleWidget(color: Colors.red),
                    CircleWidget(color: Colors.amber),
                    CircleWidget(color: Colors.blue),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                spacing: 0,
                runSpacing: 0,
                children: [
                  CircleWidget(color: Colors.orange),
                  CircleWidget(color: Colors.teal),
                  CircleWidget(color: Colors.yellow),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                spacing: 0,
                runSpacing: 0,
                children: [
                  CircleWidget(color: Colors.pinkAccent),
                  CircleWidget(color: Colors.teal),
                  CircleWidget(color: Colors.amber),
                  CircleWidget(color: Colors.yellow),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleWidget extends StatefulWidget {
  final double padding;
  final Color color;
  const CircleWidget({required this.color, super.key, this.padding = 0});

  @override
  State<CircleWidget> createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  double containerSize = 48;

  void _animateContainer() {
    _controller?.dispose();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.linearToEaseOut, // 여기에 원하는 curve를 적용
    );

    _animation =
        Tween<double>(
          begin: containerSize,
          end: containerSize + 20,
        ).animate(_animation!)..addListener(() {
          setState(() {
            containerSize = _animation!.value;
          });
        });
    _controller!.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animateContainer();
      },
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
