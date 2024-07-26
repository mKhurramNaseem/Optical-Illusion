import 'dart:async';
import 'package:flutter/material.dart';
import 'package:optical_illusion/ball_circle_paint.dart';

class OpticalIllusion extends StatefulWidget {
  const OpticalIllusion({super.key});

  @override
  State<OpticalIllusion> createState() => _OpticalIllusionState();
}

class _OpticalIllusionState extends State<OpticalIllusion> {
  // Constants
  static const _containerSize = Size(300, 300);
  static const _title = 'Optical Illusion \u{1F648}';
  static const _initialCount = 1;
  static const _initialAngle = 0.0, _maxAngle = 360.0;
  static const _delayDuration = Duration(milliseconds: 8);
  // Instance members => flags
  double angle = _initialAngle;
  bool showLines = false;
  int ballCount = _initialCount;

  @override
  void initState() {
    super.initState();
    // Setting a periodic Timer to keep balls moving
    Timer.periodic(
      _delayDuration,
      (timer) {
        setState(() {
          if (angle < _maxAngle) {
            angle++;
          } else {
            angle = _initialAngle;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
        ),
        body: Center(
          child: SizedBox(
            width: _containerSize.width,
            height: _containerSize.height,
            child: CustomPaint(
              painter: BallCirclePainter(
                angle: angle,
                showLines: showLines,
                ballsCount: ballCount,
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          FloatingActionButton(
            onPressed: () {
              showLines = !showLines;
            },
            child: Icon(
              showLines ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          FloatingActionButton(
            onPressed: () {                            
              if (ballCount < BallCirclePainter.ballAngles.length) {
                ballCount++;
              } else {
                ballCount = _initialCount;
              }
            },
            child: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
