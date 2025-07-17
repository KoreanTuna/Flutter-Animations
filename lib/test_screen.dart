import 'package:animations/animations/money_board.dart';
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

        backgroundColor: Colors.indigo,
        body: Center(child: MoneyBoard()),
      ),
    );
  }
}
