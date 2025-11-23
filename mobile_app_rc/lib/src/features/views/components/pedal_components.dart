import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rc/src/features/viewmodels/car_viewmodel.dart';
import 'package:rc/src/res/assets.dart';
import 'package:rc/src/shared/pedal_icon.dart';

class PedalComponents extends StatelessWidget {
  const PedalComponents({super.key});

  @override
  Widget build(BuildContext context) {
    final carC = Get.find<CarViewmodel>();
    return Row(
      children: [
        // PedalIcon(pedal: IconAssets.clutch),
        // SizedBox(width: 15),
        Obx(
          () => PedalIcon(
            onLongPressStart: (LongPressStartDetails press) =>
                carC.isBrakeClicked.value = true,
            onLongPressEnd: (LongPressEndDetails press) =>
                carC.isBrakeClicked.value = false,
            paddingTop: carC.isBrakeClicked.value ? 20 : 0,
            pedal: IconAssets.brake,
          ),
        ),

        const SizedBox(width: 20),

        Obx(
          () => PedalIcon(
            onLongPressStart: (LongPressStartDetails press) =>
                carC.isThrottleClicked.value = true,
            onLongPressEnd: (LongPressEndDetails press) =>
                carC.isThrottleClicked.value = false,
            paddingTop: carC.isThrottleClicked.value ? 20 : 0,

            pedal: IconAssets.throttle,
          ),
        ),

        const SizedBox(width: 15),
      ],
    );
  }
}
