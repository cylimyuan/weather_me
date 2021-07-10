import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_me/data/api/open_weather_api.dart';
import 'package:weather_me/data/model/forecast.dart';
import 'package:weather_me/data/model/forecast5.dart';
import 'package:weather_me/data/model/forecast_city.dart';
import 'package:weather_me/data/repository/weather_repo.dart';
import 'package:weather_me/util/date_formatter.dart';

part 'weather_forecast_event.dart';
part 'weather_forecast_state.dart';

class WeatherForecastBloc
    extends Bloc<WeatherForecastEvent, WeatherForecastState> {
  final WeatherRepo weatherRepo = WeatherRepo(weatherApi: OpenWeatherMapApi());

  WeatherForecastBloc() : super(WeatherInitial());

  @override
  Stream<WeatherForecastState> mapEventToState(
    WeatherForecastEvent event,
  ) async* {
    if (event is WeatherForecastCityChangedEvent) {
      final ForecastCity? city = event.city;
      if (city is ForecastCity) {
        yield await _fetchLocalForecastData(city);
      } else {
        yield WeatherForecastEmptyCitySelectionState();
      }
    } else if (event is WeatherForecastCityRemoteLoadedEvent) {
      if (!event.city.currentLocationNotLoaded &&
          await _saveRemoteDataToLocal(event)) {
        yield await _fetchLocalForecastData(event.city);
      } else {
        yield WeatherForecastErrorState(event.city);
      }
    } else if (event is WeatherForecastRemoteErrorEvent) {
      yield WeatherForecastErrorState(event.city);
    }
  }

  Future<WeatherForecastState> _fetchLocalForecastData(
      ForecastCity city) async {
    Forecast5? _localWeatherForecast;

    if (city.currentLocationNotLoaded) {
      return WeatherForecastErrorState(city);
    }

    try {
      _localWeatherForecast = await weatherRepo.getLocalForcastData(city);
    } catch (e) {
      await weatherRepo.clearLocalForecastData(city);
    }

    var shouldFetchRemote = true;

    shouldFetchRemote = _localWeatherForecast == null ||
        (await weatherRepo.isLocalDataOutdated(city));

    if (shouldFetchRemote) {
      _fetchRemoteForecastData(city);
    }

    return WeatherForecastLoaded(city,
        forecast5: _localWeatherForecast, loadingRemote: shouldFetchRemote);
  }

  Future _fetchRemoteForecastData(ForecastCity city) async {
    try {
      final Forecast5 forecast5 =
          await weatherRepo.get5DayForcast(cityName: city.name);
      add(WeatherForecastCityRemoteLoadedEvent(city, forecast5));
    } catch (e) {
      add(WeatherForecastRemoteErrorEvent(city));
    }
  }

  Future<bool> _saveRemoteDataToLocal(
      WeatherForecastCityRemoteLoadedEvent event) async {
    return weatherRepo.saveForecastDataToLocal(event.forecast5, event.city);
  }
}
