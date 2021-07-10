import 'package:http/http.dart' as http;
import 'package:weather_me/data/api/api_endpoint.dart';

class OpenWeatherMapApi {
  final apiKey = '{USE YOUR OWN KEY}';

  Future<http.Response> forcast5(String cityName) async {
    final params = {'units': 'metric', 'appid': apiKey, 'q': cityName};
    final uri = Uri.https(openWeatherBaseUrl, openWeatherForecast5, params);
    return http.get(uri);
  }

  Future<http.Response> reverseGeocoding(double lat, double lng) async {
    final params = {
      'lat': lat.toString(),
      'lon': lng.toString(),
      'limit': 1.toString(),
      'appid': apiKey
    };
    final uri =
        Uri.https(openWeatherBaseUrl, openWeatherReverseGeocoding, params);
    return http.get(uri);
  }
}
