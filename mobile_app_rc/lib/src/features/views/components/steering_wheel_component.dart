import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rc/src/features/viewmodels/car_viewmodel.dart';
import 'package:rc/src/res/angles.dart';
import 'package:rc/src/res/constant.dart';
import 'package:rc/src/shared/steering_wheel_icon.dart';

class Steeringwheelcomponent extends StatelessWidget {
  const Steeringwheelcomponent({super.key});

  @override
  Widget build(BuildContext context) {
    final carC = Get.find<CarViewmodel>();

    return Row(
      children: [
        Obx(
          () => SteeringWheelIcon(
            onLongPressStart: (press) {
              carC.isLeftClicked.value = true;
              carC.startSteering(CommandString.servoLeft);
            },
            onLongPressEnd: (press) {
              carC.isLeftClicked.value = false;
              carC.stopSteering();
            },
            scale: carC.isLeftClicked.value ? 0.8 : 1,
            angle: SteeringAngle.left,
          ),
        ),

        const SizedBox(width: 15),

        Obx(
          () => SteeringWheelIcon(
            onLongPressStart: (press) {
              carC.isRightClicked.value = true;
              carC.startSteering(CommandString.servoRight);
            },
            onLongPressEnd: (press) {
              carC.isRightClicked.value = false;
              carC.stopSteering();
            },
            scale: carC.isRightClicked.value ? 0.8 : 1,
            angle: SteeringAngle.right,
          ),
        ),
      ],
    );
  }
}
