import 'package:flutter/material.dart';
import 'package:weather_me/widget/weather/city_carousel.dart';
import 'package:weather_me/widget/weather/weather_background.dart';
import 'package:weather_me/widget/weather/weather_week_day_list.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WeatherBackground(),
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .125),
            child: _buildBody(),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        CityCarousel(),
        const Divider(),
        Expanded(child: WeatherWeekDayList())
      ],
    );
  }
}
