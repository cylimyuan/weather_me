import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:weather_me/config/asset_lib.dart';
import 'package:weather_me/data/model/forecast_city.dart';

class CityRepo {
  Future<List<ForecastCity>> getMalaysiaCities() async {
    final String rawCities = await rootBundle.loadString(jsonCities);

    final cityStateMap =
        Map<String, List<dynamic>>.from(json.decode(rawCities) as Map);
    final List<ForecastCity> allCities = [];

    cityStateMap.forEach((state, cities) {
      allCities.addAll(cities
          .map((city) => ForecastCity(city.toString(), state: state))
          .toList());
    });
    allCities.insert(0, const ForecastCity("", type: ForecastCityType.latlng));
    return allCities;
  }
}
