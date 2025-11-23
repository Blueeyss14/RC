import 'package:flutter/material.dart';
import 'package:rc/src/shared/pedal.dart';

class Car extends StatelessWidget {
  const Car({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(alignment: Alignment.bottomCenter, children: [Pedal()]),
    );
  }
}
