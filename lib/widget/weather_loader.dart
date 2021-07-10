import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Lottie.asset(
        'assets/lottie/weatherloader.json',
      ),
    );
  }
}
