import 'package:bloc/bloc.dart';
import 'package:weather_me/data/model/forecast_city.dart';
import 'package:weather_me/data/repository/city_repo.dart';

class CityListCubit extends Cubit<CityListCubitState> {
  CityRepo cityRepo = CityRepo();
  List<ForecastCity> cities = [];

  CityListCubit() : super(CityListCubitState()) {
    _getLocalCity();
  }

  Future _getLocalCity() async {
    cities = await cityRepo.getMalaysiaCities();
    emit(CityListCubitState(cities: cities));
  }

  void filterCities(String name) {
    if (name.isEmpty) {
      emit(CityListCubitState(cities: cities));
    } else {
      final List<ForecastCity> filteredCities = cities
          .where((city) => city.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
      emit(CityListCubitState(cities: filteredCities, isFiltered: true));
    }
  }
}

class CityListCubitState {
  final List<ForecastCity> cities;
  final bool isFiltered;
  CityListCubitState({this.cities = const [], this.isFiltered = false});
}
