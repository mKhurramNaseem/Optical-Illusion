
import 'dart:async';
import 'dart:math' as math; 

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? timer;
  Size size = const Size(200, 200);
  int currentTurn = 0;
  List<Ball> balls = [];
  List<(Alignment, Alignment)> alignments = [];

  @override
  void initState() {
    super.initState();
    alignments = [
      for (int i = 0; i < angles.length; i++) getAlignmentFromAngle(angles[i]),
    ];
    balls = [
      for (int i = 0; i < alignments.length; i++)
        Ball(
          color: Colors.red,
          startAlign: alignments[i].$1,
          endAlign: alignments[i].$2,
          isAnimate: false,
          isForward: true,
        ),
    ];
    timer = Timer.periodic(
      const Duration(milliseconds: 700),
      (timer) {
        setState(() {
          if (currentTurn < balls.length) {
            balls[currentTurn].copyWith(isAnimate: true);
          } else {
            currentTurn = 0;
          }
          currentTurn++;
        });
      },
    );
  }

  (Alignment, Alignment) getAlignmentFromAngle(double angle) {
    var offset = getOffsetFromAlignment(
      const Alignment(0, 0),
      size,
    );
    var endCircumPoint = getCircumPoint(size.height / 2, angle, offset);
    var endAlignment = getAlignmentFromOffset(endCircumPoint, size);
    var startCircumPoint = getCircumPoint(size.height / 2, angle + 180, offset);
    var startAlignment = getAlignmentFromOffset(startCircumPoint, size);
    return (startAlignment, endAlignment);
  }

  Offset getCircumPoint(double radius, double angle, Offset centerOffset) {
    double x = radius * math.cos(degreeToRad(angle)) + centerOffset.dx;
    double y = radius * math.sin(degreeToRad(angle)) + centerOffset.dy;
    return Offset(x, y);
  }

  double degreeToRad(double degree) {
    return math.pi / 180 * degree;
  }

  Alignment getAlignmentFromOffset(Offset offset, Size size) {
    double alignmentX = (offset.dx - size.width / 2) / (size.width / 2);
    double alignmentY = (offset.dy - size.height / 2) / (size.height / 2);
    return Alignment(alignmentX, alignmentY);
  }

  Offset getOffsetFromAlignment(Alignment alignment, Size size) {
    double offsetX = alignment.x * size.width / 2 + size.width / 2;
    double offsetY = alignment.y * size.height / 2 + size.height / 2;
    return Offset(offsetX, offsetY);
  }

  List<double> angles = [0, 45, 90, 135];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: size.width,
          height: size.height,
          decoration:
              const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          child: Stack(
            children: [
              for (int i = 0; i < balls.length; i++)
                BallWidget(
                  ball: balls[i],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (timer != null) {
            if (timer!.isActive) {
              timer!.cancel();
            }
          }
        },
      ),
    );
  }
}

class BallWidget extends StatefulWidget {
  static const animationDuration = Duration(milliseconds: 2000);
  final Ball ball;
  const BallWidget({
    super.key,
    required this.ball,
  });

  @override
  State<BallWidget> createState() => _BallWidgetState();
}

class _BallWidgetState extends State<BallWidget> {
  @override
  Widget build(BuildContext context) {
    AlignmentTween tween = AlignmentTween(
        begin: widget.ball.startAlign, end: widget.ball.endAlign);
    if (widget.ball.isAnimate) {
      if (widget.ball.isForward) {
        tween = AlignmentTween(
          begin: widget.ball.startAlign,
          end: widget.ball.endAlign,
        );
      } else {
        tween = AlignmentTween(
          begin: widget.ball.endAlign,
          end: widget.ball.startAlign,
        );
      }
    } else {
      if (widget.ball.isForward) {
        tween = AlignmentTween(
            begin: widget.ball.startAlign, end: widget.ball.startAlign);
      } else {
        tween = AlignmentTween(
            begin: widget.ball.endAlign, end: widget.ball.endAlign);
      }
    }
    return Positioned.fill(
      child: TweenAnimationBuilder<Alignment>(
        duration: BallWidget.animationDuration,
        tween: tween,
        builder: (context, value, child) {
          return Align(
            alignment: value,
            child: child,
          );
        },
        onEnd: () {
          setState(() {
            widget.ball.isForward = !widget.ball.isForward;
          });
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: widget.ball.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class Ball {
  Color color;
  Alignment startAlign;
  Alignment endAlign;
  bool isAnimate;
  bool isForward;
  Ball({
    required this.color,
    required this.startAlign,
    required this.endAlign,
    required this.isAnimate,
    required this.isForward,
  });

  void copyWith({
    Color? color,
    Alignment? startAlign,
    Alignment? endAlign,
    bool? isAnimate,
    bool? isForward,
    int? initialDelay,
  }) {
    this.color = color ?? this.color;
    this.startAlign = startAlign ?? this.startAlign;
    this.endAlign = endAlign ?? this.endAlign;
    this.isAnimate = isAnimate ?? this.isAnimate;
    this.isForward = isForward ?? this.isForward;
  }
}
