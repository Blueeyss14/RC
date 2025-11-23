import 'package:flutter/material.dart';
import 'package:rc/src/res/angles.dart';
import 'package:rc/src/res/assets.dart';

class SteeringWheelIcon extends StatefulWidget {
  final String? pedal;
  final double? angle;
  const SteeringWheelIcon({super.key, this.pedal, this.angle});

  @override
  State<SteeringWheelIcon> createState() => _SteeringWheelIconState();
}

class _SteeringWheelIconState extends State<SteeringWheelIcon> {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: widget.angle ?? SteeringAngle.left,
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Image.asset(
          widget.pedal ?? IconAssets.arrow,
          height: double.infinity / 2,
        ),
      ),
    );
  }
}
