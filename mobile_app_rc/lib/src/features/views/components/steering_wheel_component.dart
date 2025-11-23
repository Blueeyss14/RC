import 'package:flutter/material.dart';
import 'package:rc/src/res/angles.dart';
import 'package:rc/src/shared/steering_wheel_icon.dart';

class Steeringwheelcomponent extends StatelessWidget {
  const Steeringwheelcomponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SteeringWheelIcon(angle: SteeringAngle.left),
        SizedBox(width: 15),
        SteeringWheelIcon(angle: SteeringAngle.right),
      ],
    );
  }
}
