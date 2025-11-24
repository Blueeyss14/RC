import 'package:flutter/material.dart';
import 'package:rc/src/res/colors.dart';

class CarLoading extends StatelessWidget {
  const CarLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 1.5,
        color: CarColors.darkBlue,
      ),
    );
  }
}
