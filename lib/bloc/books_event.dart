import '../domain/entities/city.dart';

sealed class BooksEvent {}

class BooksLoadRequested extends BooksEvent {}

class CityAdded extends BooksEvent {
  final City city;
  CityAdded(this.city);
}

class CityDeleted extends BooksEvent {
  final String cityId;
  CityDeleted(this.cityId);
}

class FavoriteToggled extends BooksEvent {
  final String cityId;
  FavoriteToggled(this.cityId);
}

class FilterToggled extends BooksEvent {}

class SearchChanged extends BooksEvent {
  final String query;
  SearchChanged(this.query);
}

class UidUpdated extends BooksEvent {
  final String? uid;
  UidUpdated(this.uid);
}