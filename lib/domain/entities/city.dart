enum CityType { ancient, cultural, industrial }

class City {
  final String? id;
  final String title;
  final String description;
  final String cityName;
  final String assetPath;
  final String displayLetter;
  final CityType type;

  const City({
    this.id,
    required this.title,
    required this.description,
    required this.cityName,
    required this.assetPath,
    required this.displayLetter,
    required this.type,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      cityName: json['cityName'] as String,
      assetPath: json['assetPath'] as String,
      displayLetter: json['displayLetter'] as String,
      type: CityType.values.byName(json['type'] as String),
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