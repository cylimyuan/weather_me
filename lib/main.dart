import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_me/bloc/geocoding/geocoding_cubit.dart';
import 'package:weather_me/bloc/user_city/user_city_cubit.dart';
import 'package:weather_me/bloc/weather_forecast/weather_forecast_bloc.dart';
import 'package:weather_me/config/theme.dart';
import 'package:weather_me/page/city_search_page.dart';
import 'package:weather_me/page/homepage.dart';
import 'package:path_provider/path_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(WeatherMeApp());
}

class WeatherMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GeocodingCubit _geocodingCubit = GeocodingCubit();
    final UserCityCubit _userCityCubit = UserCityCubit(_geocodingCubit);
    final WeatherForecastBloc _weatherForecastBloc = WeatherForecastBloc();

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _geocodingCubit),
          BlocProvider(create: (context) => _userCityCubit),
          BlocProvider(create: (context) => _weatherForecastBloc)
        ],
        child: MaterialApp(
          theme: appTheme,
          initialRoute: '/',
          routes: {
            '/': (_) => Homepage(),
            '/city-search': (_) => CitySearchPage()
          },
        ));
  }
}
