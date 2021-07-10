import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_me/data/api/open_weather_api.dart';
import 'package:weather_me/data/model/forecast_city.dart';
import 'package:weather_me/data/repository/geocoding_repo.dart';

part 'geocoding_state.dart';

class GeocodingCubit extends Cubit<GeocodingState> {
  final GeocodingRepo geocodingRepo =
      GeocodingRepo(weatherApi: OpenWeatherMapApi());

  GeocodingCubit() : super(GeocodingInitial());

  Future requestGeoReverse() async {
    emit(GeocodingLocating());
    final Position currentPosition = await _determinePosition();

    try {
      final ForecastCity city = await geocodingRepo.reverse(
          currentPosition.latitude, currentPosition.longitude);
      emit(GeocodingLoaded(city));
    } catch (e) {
      emit(GeocodingNoPermission());
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(GeocodingNoPermission());
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(GeocodingNoPermission());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(GeocodingNoPermission());
    }

    return Geolocator.getCurrentPosition();
  }
}
