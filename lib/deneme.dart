import 'package:flutter/material.dart';

class FlipAndLiftAnimation extends StatefulWidget {
  const FlipAndLiftAnimation({Key? key}) : super(key: key);

  @override
  _FlipAndLiftAnimationState createState() => _FlipAndLiftAnimationState();
}

class _FlipAndLiftAnimationState extends State<FlipAndLiftAnimation>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> animation;

  double boxSize = 100;
  double initialSize = 100;
  double expandedSize = 300;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: 2 * 3.14)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(3.14 * 2),
          weight: 50.0,
        ),
      ],
    ).animate(animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(164, 117, 81, 1),
        child: Center(
          child: GestureDetector(
            onTap: () async {
              animationController.isCompleted
                  ? animationController.reverse()
                  : animationController.forward();
              setState(() {
                boxSize = expandedSize;
              });
              await Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  boxSize = initialSize;
                });
              });
            },
            child: AnimatedBuilder(
              animation: animationController,
              child: AnimatedContainer(
                margin: EdgeInsets.all(50),
                height: boxSize,
                width: boxSize,
                color: Colors.red,
                duration: Duration(milliseconds: 300),
              ),
              builder: (context, child) {
                final transform = Matrix4.identity();
                transform..setEntry(3, 2, 0.001)
                ..rotateY(animation.value)
                ..scale(1.0, 1, 10);
                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: child,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
