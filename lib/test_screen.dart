import 'package:animations/animations/bubble_fab.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      maintainBottomViewPadding: true,

      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 16,
              child: BubbleFab(),
            ),
          ],
        ),
      ),
    );
  }
}
