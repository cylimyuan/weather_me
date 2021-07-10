import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintf/sprintf.dart';
import 'package:weather_me/bloc/geocoding/geocoding_cubit.dart';
import 'package:weather_me/bloc/user_city/user_city_cubit.dart';
import 'package:weather_me/bloc/weather_forecast/weather_forecast_bloc.dart';
import 'package:weather_me/data/model/forecast.dart';
import 'package:weather_me/data/model/forecast5.dart';
import 'package:weather_me/data/model/forecast_city.dart';
import 'package:weather_me/data/model/weather.dart';
import 'package:weather_me/util/date_formatter.dart';

class CityCarousel extends StatefulWidget {
  @override
  _CityCarouselState createState() => _CityCarouselState();
}

class _CityCarouselState extends State<CityCarousel> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherForecastBloc>().add(WeatherForecastCityChangedEvent(
        context.read<UserCityCubit>().state.cities.first));

    context.read<GeocodingCubit>().stream.listen((event) {
      final weatherState = context.read<WeatherForecastBloc>().state;
      if (event is GeocodingLoaded &&
          weatherState is WeatherForecastErrorState) {
        if (weatherState.city.type == ForecastCityType.latlng) {
          context
              .read<WeatherForecastBloc>()
              .add(WeatherForecastCityChangedEvent(event.city));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        child: BlocBuilder<UserCityCubit, UserCityCubitState>(
            builder: (context, state) {
          final List<ForecastCity> userCities = state.cities;
          return CarouselSlider.builder(
              itemCount: userCities.length + 1,
              itemBuilder: (context, index, _) {
                final bool isLastCard = index == userCities.length;

                return Card(
                  child: isLastCard
                      ? _buildNewCityView()
                      : _buildCityForcastCard(userCities[index]),
                );
              },
              options: CarouselOptions(
                  onPageChanged: (index, _) => index < userCities.length
                      ? context.read<WeatherForecastBloc>().add(
                          WeatherForecastCityChangedEvent(userCities[index]))
                      : context
                          .read<WeatherForecastBloc>()
                          .add(WeatherForecastCityChangedEvent(null)),
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  disableCenter: true,
                  enableInfiniteScroll: false));
        }));
  }

  Widget _buildCityForcastCard(ForecastCity city) {
    if (city.currentLocationNotLoaded) {
      return _buildLocationServiceView();
    }
    return GestureDetector(
      onLongPress: () => _showConfirmRemoveCityDialog(city),
      child: BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
        builder: (context, state) {
          if (state is WeatherForecastLoaded) {
            return _buildCityForecastView(state, city);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(city.name),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildLocationServiceView() {
    return BlocBuilder<GeocodingCubit, GeocodingState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () => state is GeocodingNoPermission
            ? context.read<GeocodingCubit>().requestGeoReverse()
            : null,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Location',
              style: Theme.of(context).textTheme.headline5,
            ),
            if (state is GeocodingNoPermission)
              Text(
                'Location Not Found',
                style: Theme.of(context).textTheme.caption,
              ),
            if (state is GeocodingNoPermission)
              Text(
                'Press to try again',
                style: Theme.of(context).textTheme.caption,
              ),
            if (state is GeocodingLocating)
              Text(
                'Getting location...',
                style: Theme.of(context).textTheme.caption,
              )
          ],
        )),
      );
    });
  }

  Widget _buildCityForecastView(
      WeatherForecastLoaded state, ForecastCity city) {
    final Forecast5? forecast5 = state.forecast5;
    final Forecast? forecast = state.forecastNow;

    if (state.city == city && forecast is Forecast && forecast5 is Forecast5) {
      final Weather weather = forecast.weather.first;
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            color: Colors.orange,
                            imageUrl: weather.iconUrl,
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.height * .1,
                          ),
                          Text(weather.main),
                        ],
                      )),
                  Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (city.type == ForecastCityType.latlng)
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                Text(
                                  '[CURRENT LOCATION]',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          Text(
                            city.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            sprintf('%.1f°C', [forecast.main.temp]),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            sprintf('Huminity Level: %.0f',
                                [forecast.main.humidity]),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            if (forecast5.createdAt != null)
              Text(
                sprintf('Last update: %s',
                    [stdDateTimeFormat.format(forecast5.createdAt!)]),
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontSize: 8, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ));
  }

  Widget _buildNewCityView() => InkWell(
        onTap: () async {
          final city = await Navigator.of(context).pushNamed('/city-search');
          if (city is ForecastCity) {
            if (await context.read<UserCityCubit>().addCity(city)) {
              context
                  .read<WeatherForecastBloc>()
                  .add(WeatherForecastCityChangedEvent(city));
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Icon(Icons.add), Text('Add Cities')],
        ),
      );

  Future _showConfirmRemoveCityDialog(ForecastCity city) async {
    if (context.read<UserCityCubit>().state.cities.length > 1) {
      final delete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Delete ${city.name}?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No')),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes')),
                ],
              ));
      if (delete is bool && delete) {
        final int originalIndex =
            context.read<UserCityCubit>().state.cities.indexOf(city);
        context.read<UserCityCubit>().removeCity(city);
        final List<ForecastCity> cities =
            context.read<UserCityCubit>().state.cities;
        final int newIndex =
            originalIndex >= cities.length ? cities.length - 1 : originalIndex;
        context
            .read<WeatherForecastBloc>()
            .add(WeatherForecastCityChangedEvent(cities[newIndex]));
      }
    }
  }
}
