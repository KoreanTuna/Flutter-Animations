import 'package:animations/animations/layer_3d/layer_3d.dart';
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
        body: Center(child: Layer3DAnimation()),
      ),
    );
  }
}
