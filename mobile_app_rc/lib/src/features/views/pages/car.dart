import 'package:flutter/material.dart';
import 'package:rc/src/features/views/components/pedal_components.dart';
import 'package:rc/src/features/views/components/steering_wheel_component.dart';
import 'package:rc/src/res/assets.dart';

class Car extends StatelessWidget {
  const Car({super.key});

  @override
  Widget build(BuildContext context) {
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
          // CupertinoSwitch(value:, onChanged: onChanged)
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
