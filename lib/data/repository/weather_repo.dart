import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_database/simple_database.dart';
import 'package:weather_me/data/api/open_weather_api.dart';
import 'package:weather_me/data/model/forecast5.dart';
import 'package:weather_me/data/model/forecast_city.dart';

class WeatherRepo {
  final OpenWeatherMapApi weatherApi;

  WeatherRepo({required this.weatherApi});

  Future<Forecast5> get5DayForcast({required String cityName}) async {
    final http.Response response = await weatherApi.forcast5(cityName);
    if (response.statusCode == 200) {
      final Map<String, dynamic> valueMap =
          json.decode(response.body) as Map<String, dynamic>;
      try {
        return Forecast5.fromJson(valueMap);
      } catch (e) {
        throw Exception('Parse failed');
      }
    } else {
      throw Exception('Network Error');
    }
  }

  Future<Forecast5?> getLocalForcastData(ForecastCity city) async {
    final SimpleDatabase citiesDB = SimpleDatabase(name: city.name);
    final Map<String, dynamic> data =
        await citiesDB.getAt(0) as Map<String, dynamic>;
    final int createdAt = await citiesDB.getAt(1) as int;
    final Forecast5 forecast5 = Forecast5.fromJson(data);
    forecast5.createdAt = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return forecast5;
  }

  Future<bool> isLocalDataOutdated(ForecastCity city) async {
    final SimpleDatabase citiesDB = SimpleDatabase(name: city.name);
    final int createdAt = await citiesDB.getAt(1) as int;
    return DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(createdAt))
            .inDays >
        1;
  }

  Future<bool> saveForecastDataToLocal(
      Forecast5 forecast5, ForecastCity city) async {
    final SimpleDatabase citiesDB = SimpleDatabase(name: city.name);
    await citiesDB.add(forecast5.toJson());
    await citiesDB.add(DateTime.now().millisecondsSinceEpoch);
    return await getLocalForcastData(city) != null;
  }

  Future clearLocalForecastData(ForecastCity city) async {
    final SimpleDatabase citiesDB = SimpleDatabase(name: city.name);
    await citiesDB.clear();
  }
}
