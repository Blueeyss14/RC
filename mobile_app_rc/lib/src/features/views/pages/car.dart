import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:rc/src/features/viewmodels/car_viewmodel.dart';
import 'package:rc/src/features/views/components/camera_component.dart';
import 'package:rc/src/features/views/components/pedal_components.dart';
import 'package:rc/src/features/views/components/steering_wheel_component.dart';
import 'package:rc/src/res/angles.dart';
import 'package:rc/src/res/assets.dart';
import 'package:rc/src/res/colors.dart';

class Car extends StatelessWidget {
  const Car({super.key});

  @override
  Widget build(BuildContext context) {
    final carC = Get.find<CarViewmodel>();
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            ImageAssets.junji,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withAlpha(200),
          ),

          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CameraComponent(),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topRight,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Obx(
                        () => IntrinsicHeight(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 0),
                                  blurRadius: 2,
                                  spreadRadius: 0.5,
                                  color: Colors.black.withAlpha(50),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "D",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: carC.isGearClicked.value
                                        ? CarColors.darkBlue
                                        : CarColors.gray,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Transform.rotate(
                                    angle: SteeringAngle.right,
                                    child: CupertinoSwitch(
                                      activeTrackColor: CarColors.darkBlue,
                                      inactiveTrackColor: CarColors.red,
                                      value: carC.isGearClicked.value,
                                      onChanged: (value) {
                                        carC.isGearClicked.value =
                                            !carC.isGearClicked.value;
                                      },
                                    ),
                                  ),
                                ),

                                Text(
                                  "R",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: !carC.isGearClicked.value
                                        ? CarColors.red
                                        : CarColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.37,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Steeringwheelcomponent(), PedalComponents()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
