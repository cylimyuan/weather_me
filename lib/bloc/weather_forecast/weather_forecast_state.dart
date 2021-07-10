part of 'weather_forecast_bloc.dart';

@immutable
abstract class WeatherForecastState {}

class WeatherInitial extends WeatherForecastState {}

class WeatherForecastLoaded extends WeatherForecastState {
  final ForecastCity city;
  final Forecast5? forecast5;
  final bool loadingRemote;

  WeatherForecastLoaded(this.city,
      {this.forecast5, this.loadingRemote = false});

  Map<String, List<Forecast>> get groupByDay {
    final Map<String, List<Forecast>> data = {};
    if (forecast5 != null) {
      for (final forcast in forecast5!.list) {
        final String key = stdDateFormat.format(forcast.dateTime);
        if (!data.containsKey(key)) {
          data[key] = [];
        }
        data[key]?.add(forcast);
      }
    }
    return data;
  }

  Forecast? get forecastNow {
    final DateTime now = DateTime.now();
    final List<Forecast>? forecasts = forecast5?.list;
    if (forecasts != null) {
      return forecasts.lastWhere(
          (e) => e.dateTime.millisecondsSinceEpoch < now.millisecondsSinceEpoch,
          orElse: () => forecasts.first);
    }
    return null;
  }
}

class WeatherForecastErrorState extends WeatherForecastState {
  final ForecastCity city;
  WeatherForecastErrorState(this.city);
}

class WeatherForecastEmptyCitySelectionState extends WeatherForecastState {}
