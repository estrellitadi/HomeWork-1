import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/books_repository.dart';
import 'books_event.dart';
import 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final BooksRepository _repository;
  String? _currentUid;
  StreamSubscription? _favoritesSubscription;
  Set<String> _cachedFavorites = {};

  BooksBloc(this._repository) : super(BooksLoadInProgress()) {
    on<BooksLoadRequested>(_onLoadRequested);
    on<CityAdded>(_onCityAdded);
    on<CityDeleted>(_onCityDeleted);
    on<FavoriteToggled>(_onFavoriteToggled);
    on<FilterToggled>(_onFilterToggled);
    on<SearchChanged>(_onSearchChanged);
    on<UidUpdated>(_onUidUpdated);
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadRequested(
    BooksLoadRequested event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoadInProgress());

    await emit.forEach(
      _repository.watchCities(),
      onData: (cities) {
        final current = state;
        final onlyFavorites = current is BooksLoadSuccess ? current.onlyFavorites : false;
        final searchQuery = current is BooksLoadSuccess ? current.searchQuery : '';
        return BooksLoadSuccess(
          cities: cities,
          favorites: _cachedFavorites,
          onlyFavorites: onlyFavorites,
          searchQuery: searchQuery,
        );
      },
      onError: (_, __) => BooksLoadFailure('Не удалось загрузить каталог'),
    );
  }

  void _onUidUpdated(
    UidUpdated event,
    Emitter<BooksState> emit,
  ) {
    print('UID обновлён: ${event.uid}');
    _currentUid = event.uid;
    _favoritesSubscription?.cancel();

    if (_currentUid != null) {
      print('Подписываемся на favorites для UID: $_currentUid');
      _favoritesSubscription = _repository.watchFavorites(_currentUid!).listen(
        (favorites) {
          print('Получены favorites: $favorites');
          _cachedFavorites = favorites;

          if (state is BooksLoadSuccess) {
            final current = state as BooksLoadSuccess;
            emit(current.copyWith(favorites: favorites));
            print('Состояние обновлено с новыми favorites');
          } else {
            print('Состояние не BooksLoadSuccess, сохраняем в кэш');
          }
        },
        onError: (error) {
          print('Ошибка подписки на favorites: $error');
        },
      );
    } else {
      print('UID null, не подписываемся');
    }
  }

  Future<void> _onCityAdded(
    CityAdded event,
    Emitter<BooksState> emit,
  ) async {
    try {
      await _repository.addCity(event.city);
    } catch (e) {
      print('Ошибка добавления: $e');
    }
  }

  Future<void> _onCityDeleted(
    CityDeleted event,
    Emitter<BooksState> emit,
  ) async {
    try {
      await _repository.deleteCity(event.cityId);
    } catch (e) {
      print('Ошибка удаления: $e');
    }
  }

  Future<void> _onFavoriteToggled(
  FavoriteToggled event,
  Emitter<BooksState> emit,
) async {
  if (_currentUid == null) return;
  final state = this.state;
  if (state is! BooksLoadSuccess) return;

  final isCurrentlyLiked = state.favorites.contains(event.cityId);
  
  try {
    await _repository.toggleFavorite(_currentUid!, event.cityId, isCurrentlyLiked);
    
    final newFavorites = Set<String>.from(state.favorites);
    if (isCurrentlyLiked) {
      newFavorites.remove(event.cityId);
    } else {
      newFavorites.add(event.cityId);
    }
    
    emit(state.copyWith(favorites: newFavorites));
    _cachedFavorites = newFavorites;
  } catch (e) {
    print('Ошибка лайка: $e');
  }
}

  void _onFilterToggled(
    FilterToggled event,
    Emitter<BooksState> emit,
  ) {
    if (state is! BooksLoadSuccess) return;
    final current = state as BooksLoadSuccess;
    emit(current.copyWith(onlyFavorites: !current.onlyFavorites));
  }

  void _onSearchChanged(
    SearchChanged event,
    Emitter<BooksState> emit,
  ) {
    if (state is! BooksLoadSuccess) return;
    final current = state as BooksLoadSuccess;
    emit(current.copyWith(searchQuery: event.query));
  }
}