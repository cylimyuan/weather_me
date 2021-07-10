part of 'weather_forecast_bloc.dart';

@immutable
abstract class WeatherForecastEvent {}

class WeatherForecastCityChangedEvent extends WeatherForecastEvent {
  final ForecastCity? city;

  WeatherForecastCityChangedEvent(this.city);
}

class WeatherForecastCityRemoteLoadedEvent extends WeatherForecastEvent {
  final ForecastCity city;
  final Forecast5 forecast5;

  WeatherForecastCityRemoteLoadedEvent(this.city, this.forecast5);
}

class WeatherForecastRemoteErrorEvent extends WeatherForecastEvent {
  final ForecastCity city;

  WeatherForecastRemoteErrorEvent(this.city);
}
