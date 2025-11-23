import 'package:flutter/material.dart';
import 'package:rc/src/res/assets.dart';

class PedalIcon extends StatelessWidget {
  final String? pedal;
  final double? paddingTop;
  final void Function(LongPressStartDetails)? onLongPressStart;
  final void Function(LongPressEndDetails)? onLongPressEnd;

  const PedalIcon({
    super.key,
    this.pedal,
    this.paddingTop,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      child: AnimatedPadding(
        padding: EdgeInsets.only(top: paddingTop ?? 0),
        duration: const Duration(milliseconds: 100),
        child: Image.asset(
          pedal ?? IconAssets.throttle,
          height: double.infinity,
        ),
      ),
    );
  }
}
