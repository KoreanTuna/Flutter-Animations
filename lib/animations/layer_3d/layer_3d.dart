import 'package:animations/animations/layer_3d/widget/base_layer.dart';
import 'package:animations/animations/layer_3d/widget/border_layer.dart';
import 'package:animations/animations/layer_3d/widget/padding_layer.dart';
import 'package:animations/animations/layer_3d/widget/shadow_layer.dart';
import 'package:flutter/material.dart';

class Layer3DAnimation extends StatefulWidget {
  const Layer3DAnimation({super.key});

  @override
  State<Layer3DAnimation> createState() => _Layer3DAnimationState();
}

class _Layer3DAnimationState extends State<Layer3DAnimation>
    with TickerProviderStateMixin {
  late final AnimationController animationXController;
  late final AnimationController animationYController;

  late final Animation<double> rotateXAnimation;
  late final Animation<double> rotateZAnimation;

  late final Animation<double> paddingOpacityAnimation;

  late final Animation backgroundColorAnimation;
  late final AnimationController backgroundColorController;

  late final Animation textColorAnimation;

  late final Animation<double> textXOffset;
  late final Animation<double> textYOffset;

  late final Animation<double> paddingXOffset;
  late final Animation<double> paddingYOffset;

  late final Animation<double> borderXOffset;
  late final Animation<double> borderYOffset;

  late final Animation<double> baseXOffset;
  late final Animation<double> baseYOffset;

  late final Animation<double> shadowXOffset;
  late final Animation<double> shadowYOffset;

  @override
  void initState() {
    super.initState();
    animationXController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    animationYController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    backgroundColorController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    final curveX = CurvedAnimation(
      parent: animationXController,
      curve: Curves.easeInOut,
    );
    final curveY = CurvedAnimation(
      parent: animationYController,
      curve: Curves.easeInOut,
    );

    rotateXAnimation = Tween(begin: 0.0, end: 0.85).animate(curveX);
    rotateZAnimation = Tween(begin: 0.0, end: 0.75).animate(curveY);

    paddingOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(curveX);
    backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: const Color(0xFF3A3B40),
    ).animate(backgroundColorController);

    textColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(curveX);

    textXOffset = Tween(begin: 0.0, end: -150.0).animate(curveX);
    textYOffset = Tween(begin: 0.0, end: -280.0).animate(curveY);

    paddingXOffset = Tween(begin: 0.0, end: -70.0).animate(curveX);
    paddingYOffset = Tween(begin: 0.0, end: -200.0).animate(curveY);

    borderXOffset = Tween(begin: 0.0, end: -10.0).animate(curveX);
    borderYOffset = Tween(begin: 0.0, end: -130.0).animate(curveY);

    baseXOffset = Tween(begin: 0.0, end: 50.0).animate(curveX);
    baseYOffset = Tween(begin: 0.0, end: -70.0).animate(curveY);

    shadowXOffset = Tween(begin: 0.0, end: 110.0).animate(curveX);
    shadowYOffset = Tween(begin: 0.0, end: 0.0).animate(curveY);
  }

  @override
  void dispose() {
    animationXController.dispose();
    animationYController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (animationXController.isCompleted ||
            animationYController.isCompleted) {
          animationXController.reverse();
          animationYController.reverse();
          backgroundColorController.reverse();
        } else {
          animationXController.forward();
          animationYController.forward();
          backgroundColorController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: animationXController,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: backgroundColorAnimation.value,
            body: Center(
              child: SizedBox(
                width: 180,
                height: 180,
                child: Transform(
                  transform: Matrix4.identity()
                    ..rotateX(rotateXAnimation.value)
                    ..rotateZ(rotateZAnimation.value),
                  child: Stack(
                    children: [
                      Transform.translate(
                        offset: Offset(textXOffset.value, textYOffset.value),
                        child: Container(
                          width: 180,
                          height: 180,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: paddingOpacityAnimation.value,
                              ),
                            ),
                          ),
                          child: Text(
                            '최고의 결제\n최고의 경험',
                            style: TextStyle(
                              color: textColorAnimation.value,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: paddingOpacityAnimation.value,
                        child: Transform.translate(
                          offset: Offset(
                            paddingXOffset.value,
                            paddingYOffset.value,
                          ),
                          child: const PaddingLayerWidget(),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                          borderXOffset.value,
                          borderYOffset.value,
                        ),
                        child: const BorderLayerWidget(),
                      ),
                      Transform.translate(
                        offset: Offset(baseXOffset.value, baseYOffset.value),
                        child: const BaseLayerWidget(),
                      ),
                      Transform.translate(
                        offset: Offset(
                          shadowXOffset.value,
                          shadowYOffset.value,
                        ),
                        child: const ShadowLayerWidget(),
                      ),
                    ].reversed.toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
