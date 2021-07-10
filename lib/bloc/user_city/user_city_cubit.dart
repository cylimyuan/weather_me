import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_me/bloc/geocoding/geocoding_cubit.dart';
import 'package:weather_me/data/model/forecast_city.dart';
import 'package:collection/collection.dart';

class UserCityCubit extends HydratedCubit<UserCityCubitState> {
  final GeocodingCubit geocodingCubit;

  UserCityCubit(this.geocodingCubit)
      : super(UserCityCubitState([const ForecastCity('Kuala Lumpur')])) {
    _loadGeocoding();
  }

  Future<bool> addCity(ForecastCity city) async {
    if (!state.cities.contains(city)) {
      emit(state.copyWith(cities: [...state.cities, city]));
      if (city.type == ForecastCityType.latlng) {
        geocodingCubit.requestGeoReverse();
      }
      return true;
    } else {
      return false;
    }
  }

  void removeCity(ForecastCity cityToRemove) {
    emit(state.copyWith(
        cities: state.cities.where((city) => city != cityToRemove).toList()));
  }

  void _loadGeocoding() {
    if (state.cities
            .firstWhereOrNull((e) => e.type == ForecastCityType.latlng) !=
        null) {
      geocodingCubit.requestGeoReverse();
    }
    geocodingCubit.stream.listen((event) {
      if (event is GeocodingLoaded) {
        emit(state.copyWith(
            cities: state.cities.map((city) {
          if (city.type == ForecastCityType.latlng) {
            return event.city;
          }
          return city;
        }).toList()));
      }
    });
  }

  @override
  Map<String, dynamic>? toJson(UserCityCubitState state) =>
      {'cities': state.cities.map((e) => e.toJson()).toList()};

  @override
  UserCityCubitState? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('cities')) {
      final cities = (json['cities'] as List<dynamic>)
          .map((e) => ForecastCity.fromJson(e as Map<String, dynamic>))
          .toList();
      if (cities.isNotEmpty) {
        return UserCityCubitState(cities);
      }
    }
    return UserCityCubitState([const ForecastCity('Kuala Lumpur')]);
  }
}

class UserCityCubitState {
  final List<ForecastCity> cities;

  UserCityCubitState(this.cities);

  UserCityCubitState copyWith(
      {List<ForecastCity>? cities, int? selectedIndex}) {
    return UserCityCubitState(cities ?? this.cities);
  }
}
