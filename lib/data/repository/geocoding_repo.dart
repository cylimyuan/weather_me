import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_me/data/api/open_weather_api.dart';
import 'package:weather_me/data/model/forecast_city.dart';

class GeocodingRepo {
  final OpenWeatherMapApi weatherApi;

  GeocodingRepo({required this.weatherApi});

  Future<ForecastCity> reverse(double lat, double lng) async {
    final http.Response response = await weatherApi.reverseGeocoding(lat, lng);
    if (response.statusCode == 200) {
      final List valueMap = json.decode(response.body) as List;
      if (valueMap.isEmpty) {
        throw Exception('Getting Location Failed.');
      }

      try {
        final data = valueMap.first as Map<String, dynamic>;
        return ForecastCity(data['name'].toString(),
            type: ForecastCityType.latlng);
      } catch (e) {
        throw Exception('Parse failed');
      }
    } else {
      throw Exception('Network Error');
    }
  }
}
