import '../domain/entities/city.dart';

sealed class BooksState {}

class BooksLoadInProgress extends BooksState {}

class BooksLoadSuccess extends BooksState {
  final List<City> books;
  BooksLoadSuccess(this.books);
}

class BooksLoadFailure extends BooksState {
  final String message;
  BooksLoadFailure(this.message);
}
