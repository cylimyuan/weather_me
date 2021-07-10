import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:weather_me/data/model/forecast.dart';
import 'package:weather_me/util/date_formatter.dart';

class WeatherWeekDayListItem extends StatelessWidget {
  final Forecast forecast;
  final bool isNow;

  const WeatherWeekDayListItem(this.forecast, {this.isNow = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          sprintf('%.1f°C', [forecast.main.temp]),
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          sprintf('Huminity Level: %.0f', [forecast.main.humidity]),
          style: Theme.of(context).textTheme.caption,
        ),
        leading: Column(
          children: [
            CachedNetworkImage(
              width: 40,
              color: Colors.orange,
              imageUrl: forecast.weather.first.iconUrl,
            ),
            Text(forecast.weather.first.main.toUpperCase(),
                style: Theme.of(context).textTheme.overline)
          ],
        ),
        trailing: Text(
            isNow ? 'NOW' : stdReadableHourFormat.format(forecast.dateTime),
            style: Theme.of(context).textTheme.bodyText1),
      ),
    );
  }
}
