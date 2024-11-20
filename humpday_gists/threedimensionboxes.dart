/// 3D tile wip
/// Fixme: proper tap/hover area
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    const cubeSize = Size(200, 200);
    return GestureDetector(
      onPanUpdate: (d) {
        offset += d.delta;
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            Positioned(
              bottom: (i + 0.5) * cubeSize.height,
              child: ColoredBox(
                color: Colors.pinkAccent.withOpacity(.1),
                child: Cube(
                  width: cubeSize.width,
                  height: cubeSize.height,
                  leftChild: const Center(
                    child: Text(
                      'Hey',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Cube extends StatefulWidget {
  const Cube({
    super.key,
    required this.width,
    required this.height,
    this.leftChild,
  });

  final double width;
  final double height;
  final Widget? leftChild;

  @override
  State<Cube> createState() => _CubeState();
}

class _CubeState extends State<Cube> {
  bool flagged = false;
  Matrix4 transform = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: transform,
      duration: Durations.medium1,
      child: Transform(
        alignment: Alignment.center,
        transform: (Matrix4.identity()
              //..setEntry(3, 2, 0.001) // perspective
              ..rotateX(15 * pi / 180)
              ..rotateY(-30 * pi / 180)) *
            Matrix4.translationValues(-widget.width * 0.25, 0.0, 0.0),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Transform(
              transform: Matrix4.identity()..rotateX(90 * pi / 180),
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.red,
                child: const FlutterLogo(size: 200),
              ),
            ),
            Transform(
              transform: Matrix4.identity()..rotateX(-90 * pi / 180),
              child: Material(
                color: Colors.orange,
                child: const FlutterLogo(size: 200),
              ),
            ),
            Transform(
              transform: Matrix4.identity()..rotateY(90 * pi / 180),
              child: Material(
                color: Colors.green,
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: widget.leftChild ?? const FlutterLogo(),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(0, 0, -200),
              child: Material(
                color: Colors.deepPurpleAccent,
                child: InkWell(
                  onTap: () {
                    if (flagged) {
                      transform = Matrix4.translationValues(100, 0, 0);
                    } else {
                      transform = Matrix4.identity();
                    }
                    setState(() {
                      flagged = !flagged;
                    });
                  },
                  child: const FlutterLogo(size: 200),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}