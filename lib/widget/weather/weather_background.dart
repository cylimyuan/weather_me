import 'package:flutter/material.dart';

// TODO: Colour change based on time (eg night - grey, day - blue)
class WeatherBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
      height: MediaQuery.of(context).size.height * .25,
    );
  }
}
