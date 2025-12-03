import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rc/src/features/viewmodels/car_viewmodel.dart';
import 'package:rc/src/res/colors.dart';
import 'package:rc/src/shared/car_loading.dart';

class CameraComponent extends StatelessWidget {
  const CameraComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final carC = Get.find<CarViewmodel>();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.65,
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CarColors.gray,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 0,
              spreadRadius: 0.3,
              color: Colors.black.withAlpha(100),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Obx(() {
              if (carC.currentFrame.value != null) {
                return Image.memory(
                  carC.currentFrame.value!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  cacheWidth: 480,
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CarLoading(),
                  const SizedBox(height: 10),
                  Text(carC.streamStatus.value),
                ],
              );
            }),

            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              child: const Text(
                "Warning",
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
