import 'package:cloud_firestore/cloud_firestore.dart';

enum CityType { ancient, cultural, industrial }

class City {
  final String id;
  final String title;
  final String description;
  final String cityName;
  final String assetPath;
  final String displayLetter;
  final CityType type;

  const City({
    required this.id,
    required this.title,
    required this.description,
    required this.cityName,
    required this.assetPath,
    required this.displayLetter,
    required this.type,
  });

factory City.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return City(
    id: doc.id,
    title: data['title'] as String,
    description: data['description'] as String,
    cityName: data['cityName'] as String,
    assetPath: data['assetPath'] as String,
    displayLetter: data['displayLetter'] as String,
    type: CityType.values.byName(data['type'] as String),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'cityName': cityName,
      'assetPath': assetPath,
      'displayLetter': displayLetter,
      'type': type.name,
    };
  }
}