part of 'geocoding_cubit.dart';

abstract class GeocodingState extends Equatable {
  const GeocodingState();

  @override
  List<Object> get props => [];
}

class GeocodingInitial extends GeocodingState {}

class GeocodingNoPermission extends GeocodingState {}

class GeocodingLocating extends GeocodingState {}

class GeocodingLoaded extends GeocodingState {
  final ForecastCity city;

  const GeocodingLoaded(this.city);
}
