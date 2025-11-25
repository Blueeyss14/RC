import 'package:flutter/material.dart';
import 'package:rc/src/res/angles.dart';
import 'package:rc/src/res/assets.dart';
import 'package:rc/src/res/colors.dart';

class SteeringWheelIcon extends StatelessWidget {
  final String? pedal;
  final double? angle;
  final double? scale;

  final void Function(LongPressStartDetails)? onLongPressStart;
  final void Function(LongPressEndDetails)? onLongPressEnd;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;

  const SteeringWheelIcon({
    super.key,
    this.pedal,
    this.angle,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.scale,
    this.onTapUp,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      child: AnimatedScale(
        scale: scale ?? 1,
        duration: const Duration(milliseconds: 100),
        child: Transform.rotate(
          angle: angle ?? SteeringAngle.left,
          child: FractionallySizedBox(
            heightFactor: 0.6,
            child: Image.asset(
              color: CarColors.gray,
              pedal ?? IconAssets.arrow,
              height: double.infinity / 2,
            ),
          ),
        ),
      ),
    );
  }
}
