import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsearch_nullsafety/fsearch_nullsafety.dart';
import 'package:weather_me/bloc/city_list/city_list_cubit.dart';
import 'package:weather_me/data/model/forecast_city.dart';

class CitySearchPage extends StatefulWidget {
  @override
  _CitySearchPageState createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final _cityListCubit = CityListCubit();
  final FSearchController _searchBarController = FSearchController();

  @override
  void initState() {
    super.initState();
    _searchBarController.setListener(() {
      _cityListCubit.filterCities(_searchBarController.text ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            buildFloatingSearchBar(),
            Expanded(child: _buildCitySelectionList())
          ],
        ),
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    return FSearch(
      height: 50,
      controller: _searchBarController,
      shadowColor: Colors.black38,
      shadowBlur: 5.0,
      shadowOffset: const Offset(2.0, 2.0),
      backgroundColor: Colors.white,
      prefixes: [
        IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        )
      ],
      suffixes: [
        BlocBuilder<CityListCubit, CityListCubitState>(
          bloc: _cityListCubit,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                if (state.isFiltered) {
                  _searchBarController.text = '';
                  FocusScope.of(context).unfocus();
                } else {
                  FocusScope.of(context).isFirstFocus
                      ? FocusScope.of(context).unfocus()
                      : _searchBarController.requestFocus();
                }
              },
              icon: Icon(state.isFiltered ? Icons.close : Icons.search),
            );
          },
        )
      ],
    );
  }

  Widget _buildCitySelectionList() {
    return BlocBuilder<CityListCubit, CityListCubitState>(
      bloc: _cityListCubit,
      builder: (context, state) => ListView.builder(
          itemCount: state.cities.length,
          itemBuilder: (context, index) {
            final ForecastCity city = state.cities[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).pop(city);
              },
              title: Text(city.type == ForecastCityType.latlng
                  ? 'Current Location'
                  : city.name),
              subtitle: city.state != null ? Text(city.state ?? '') : null,
              trailing: city.type == ForecastCityType.latlng
                  ? const Icon(Icons.gps_fixed)
                  : null,
            );
          }),
    );
  }
}
