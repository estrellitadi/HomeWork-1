import '../domain/entities/city.dart';

sealed class BooksState {}

class BooksLoadInProgress extends BooksState {}

class BooksLoadSuccess extends BooksState {
  final List<City> cities;
  final Set<String> favorites;
  final bool onlyFavorites;
  final String searchQuery;

  BooksLoadSuccess({
    required this.cities,
    required this.favorites,
    required this.onlyFavorites,
    this.searchQuery = '',
  });

  BooksLoadSuccess copyWith({
    List<City>? cities,
    Set<String>? favorites,
    bool? onlyFavorites,
    String? searchQuery,
  }) {
    return BooksLoadSuccess(
      cities: cities ?? this.cities,
      favorites: favorites ?? this.favorites,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<City> get visibleCities {
    var result = cities;
    
    if (searchQuery.isNotEmpty) {
      result = result.where((c) => 
        c.title.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    if (onlyFavorites) {
      result = result.where((c) => favorites.contains(c.id)).toList();
    }
    
    return result;
  }
}

class BooksLoadFailure extends BooksState {
  final String message;
  BooksLoadFailure(this.message);
}