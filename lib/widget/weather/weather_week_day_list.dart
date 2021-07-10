import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_me/bloc/geocoding/geocoding_cubit.dart';
import 'package:weather_me/bloc/weather_forecast/weather_forecast_bloc.dart';
import 'package:weather_me/data/model/forecast.dart';
import 'package:weather_me/util/date_formatter.dart';
import 'package:weather_me/widget/weather_loader.dart';
import 'package:weather_me/widget/weather/weather_week_day_list_item.dart';

class WeatherWeekDayList extends StatefulWidget {
  @override
  _WeatherWeekDayListState createState() => _WeatherWeekDayListState();
}

class _WeatherWeekDayListState extends State<WeatherWeekDayList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
        builder: (context, state) {
      if (state is WeatherForecastLoaded) {
        if (state.forecast5 == null && state.loadingRemote) {
          return _buildLoadingView();
        }
        return DefaultTabController(
          length: state.groupByDay.keys.length,
          child: Column(
            children: [
              _buildTabBar(state),
              Expanded(child: _buildTabBarView(state))
            ],
          ),
        );
      } else if (state is WeatherForecastErrorState) {
        if (state.city.currentLocationNotLoaded) {
          return BlocBuilder<GeocodingCubit, GeocodingState>(
              builder: (context, state) => state is GeocodingLocating
                  ? Center(child: WeatherLoader())
                  : Container());
        }
        return _buildErrorView();
      } else if (state is WeatherForecastEmptyCitySelectionState) {
        return const SizedBox.shrink();
      } else {
        return _buildLoadingView();
      }
    });
  }

  Widget _buildLoadingView() => Center(child: WeatherLoader());
  Widget _buildErrorView() => const Center(child: Text('Something Went Wrong'));

  TabBar _buildTabBar(WeatherForecastLoaded state) {
    return TabBar(
      isScrollable: true,
      unselectedLabelColor: Colors.black,
      indicator: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white),
      tabs: state.groupByDay.keys.map<Tab>((day) {
        final DateTime date = stdDateFormat.parse(day);
        String weekday = std3WordWeekdayFormat.format(date);
        if (stdDateFormat.format(DateTime.now()) == day) {
          weekday = "Today";
        }
        return Tab(
          child: Text(
            weekday,
            style: Theme.of(context).textTheme.overline,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTabBarView(WeatherForecastLoaded state) => Container(
        color: Colors.white,
        child: TabBarView(
            children: state.groupByDay.keys.map((e) {
          final List<Forecast> forecasts = state.groupByDay[e] ?? [];
          return ListView.builder(
              itemCount: forecasts.length,
              itemBuilder: (context, index) {
                final Forecast forecast = forecasts[index];
                return WeatherWeekDayListItem(forecasts[index],
                    isNow: forecast.dateText == state.forecastNow?.dateText);
              });
        }).toList()),
      );
}
