enum CityType { ancient, cultural, industrial }

class City {
  final int id;
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
}
