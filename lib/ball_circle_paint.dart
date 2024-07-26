import 'package:flutter/material.dart';
import 'dart:math' as math;

class BallCirclePainter extends CustomPainter {
  // Constants
  static const List<double> ballAngles = [0, 180, 90, 270, 45, 225, 315, 135];
  List<double> subListOfAngles = [];
  static const _smallBallsRadiusPercent = 0.15;
  static const _linesStrokeWidth = 5.0;
  // Instance members
  final double angle;
  final bool showLines;
  final int ballsCount;
  // Constructor
  BallCirclePainter({
    required this.angle,
    this.showLines = false,
    required this.ballsCount,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // Width & Height
    final width = size.width;
    final height = size.height;
    // Center Offset
    var centerOffset = Offset(width.half, height.half);
    // Background Circle values
    var radius = math.min(width, height).half;
    var calculationRadius = radius - radius.half * _smallBallsRadiusPercent;
    var backCirclePaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = _linesStrokeWidth
      ..style = PaintingStyle.stroke;
    // Foreground Circle => Not the small circles
    var frontCircleRadius = calculationRadius.half;
    var frontCirclePaint = Paint()..color = Colors.transparent;
    var frontCircleCenter =
        getCircumPoint(frontCircleRadius, angle, centerOffset);
    // Small Balls which seems to be rotating
    var smallCircleRadius = frontCircleRadius * _smallBallsRadiusPercent;    
    // Sublisting to show appropriate no. of balls at a time
    subListOfAngles = ballAngles.sublist(ballAngles.initialIndex, ballsCount);
    if (showLines) {
      drawLines(canvas, radius, centerOffset, smallCircleRadius.twice);
    }
    // Draw Background Circle
    canvas.drawCircle(centerOffset, radius, backCirclePaint);
    // Draw Foreground Circle => With Small balls
    canvas.drawCircle(frontCircleCenter, frontCircleRadius, frontCirclePaint);
    // Draw Small balls
    var angleList = subListOfAngles.map((e) => e - angle).toList();
    for (var i = angleList.initialIndex; i < angleList.length; i++) {
      var offset =
          getCircumPoint(frontCircleRadius, angleList[i], frontCircleCenter);
      var smallCirclePaint = Paint()
        ..color = Colors.grey
        ..shader = const LinearGradient(colors: [Colors.pink, Colors.purple])
            .createShader(Rect.fromCenter(
                center: offset,
                width: smallCircleRadius.twice,
                height: smallCircleRadius.twice));
      canvas.drawCircle(offset, smallCircleRadius, smallCirclePaint);
    }
  }

  // Draw Background Lines
  void drawLines(
      Canvas canvas, double radius, Offset centerOffset, double strokeWidth) {
    for (var single in subListOfAngles) {
      var pointOne = getCircumPoint(radius, single - single.half, centerOffset);
      var pointTwo =
          getCircumPoint(radius, single - (single.half) + 180, centerOffset);
      canvas.drawLine(
        pointOne,
        pointTwo,
        Paint()
          ..color = Colors.amber.shade200
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  // Gives an offset on circumferece of circle with radius given as parameter on base of provided angle
  Offset getCircumPoint(double radius, double angle, Offset centerOffset) {
    double x = radius * math.cos(degreeToRad(angle)) + centerOffset.dx;
    double y = radius * math.sin(degreeToRad(angle)) + centerOffset.dy;
    return Offset(x, y);
  }

  double degreeToRad(double degree) {
    return math.pi / 180 * degree;
  }

  @override
  bool shouldRepaint(BallCirclePainter oldDelegate) =>
      angle != oldDelegate.angle;

  @override
  bool shouldRebuildSemantics(BallCirclePainter oldDelegate) => false;
}

// Few extension methods to avoid redundancy
extension Modification on double {
  double get half => this / 2;
  double get twice => this * 2;
}

extension ModificationList on List {
  int get initialIndex => 0;
}
