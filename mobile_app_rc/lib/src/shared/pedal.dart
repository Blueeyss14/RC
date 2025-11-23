import 'package:flutter/material.dart';
import 'package:rc/src/res/assets.dart';

class Pedal extends StatefulWidget {
  final String? pedal;
  const Pedal({super.key, this.pedal});

  @override
  State<Pedal> createState() => PedalState();
}

class PedalState extends State<Pedal> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.pedal ?? IconAssets.throttle,
      height: double.infinity,
    );
  }
}
