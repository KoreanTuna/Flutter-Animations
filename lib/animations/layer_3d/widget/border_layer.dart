import 'package:flutter/material.dart';

class BorderLayerWidget extends StatelessWidget {
  const BorderLayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.pink,
          width: 2,
        ),
      ),
    );
  }
}
