import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/city.dart';

class BooksRepository {
  final _citiesCollection = FirebaseFirestore.instance.collection('cities');

  Stream<List<City>> watchCities() {
    return _citiesCollection.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => City.fromFirestore(doc)).toList(),
    );
  }

  Future<void> addCity(City city) {
    return _citiesCollection.add(city.toJson());
  }

  Future<void> deleteCity(String cityId) {
    return _citiesCollection.doc(cityId).delete();
  }

Stream<Set<String>> watchFavorites(String uid) {
  print('watchFavorites вызван для UID: $uid');
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('favorites')
      .snapshots()
      .map((snapshot) {
        print('Получен snapshot favorites: ${snapshot.docs.length} документов');
        return snapshot.docs.map((doc) => doc.id).toSet();
      });
}

  Future<void> toggleFavorite(String uid, String cityId, bool isLiked) {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(cityId);
    
    if (isLiked) {
      return ref.delete();
    } else {
      return ref.set({'liked': true});
    }
  }
}