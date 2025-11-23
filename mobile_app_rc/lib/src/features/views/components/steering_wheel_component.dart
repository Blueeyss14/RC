import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rc/src/features/viewmodels/car_viewmodel.dart';
import 'package:rc/src/res/angles.dart';
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
            onLongPressStart: (LongPressStartDetails press) =>
                carC.isLeftClicked.value = true,
            onLongPressEnd: (LongPressEndDetails press) =>
                carC.isLeftClicked.value = false,
            scale: carC.isLeftClicked.value ? 0.8 : 1,
            angle: SteeringAngle.left,
          ),
        ),

        const SizedBox(width: 15),
        Obx(
          () => SteeringWheelIcon(
            onLongPressStart: (LongPressStartDetails press) =>
                carC.isRightClicked.value = true,
            onLongPressEnd: (LongPressEndDetails press) =>
                carC.isRightClicked.value = false,
            scale: carC.isRightClicked.value ? 0.8 : 1,

            angle: SteeringAngle.right,
          ),
        ),
      ],
    );
  }
}
