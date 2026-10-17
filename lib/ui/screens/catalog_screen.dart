import 'package:flutter/material.dart';
import '../../domain/entities/city.dart';
import '../widgets/city_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<int> _likedCityIds = <int>{};
  bool _onlyFavorites = false;

  static const List<City> _allCities = [
    City(
      id: 1,
      title: 'Свято-Троицкая Сергиева Лавра',
      description: 'Крупнейший мужской монастырь Русской православной церкви с многовековой историей. Основан преподобным Сергием Радонежским.',
      cityName: 'Сергиев Посад',
      assetPath: 'assets/1.png',
      displayLetter: 'С',
      type: CityType.ancient,
    ),
    City(
      id: 2,
      title: 'Переславский Кремль и Спасо-Преображенский собор',
      description: 'Древнейший белокаменный храм Руси, заложенный Юрием Долгоруким. Город на берегу живописного Плещеева озера.',
      cityName: 'Переславль-Залесский',
      assetPath: 'assets/2.png',
      displayLetter: 'П',
      type: CityType.ancient,
    ),
    City(
      id: 3,
      title: 'Ростовский Кремль (Митрополичий двор)',
      description: 'Величественная резиденция митрополита с белокаменными стенами и знаменитыми ростовскими звонами. Здесь снимали фильм «Иван Васильевич меняет профессию».',
      cityName: 'Ростов Великий',
      assetPath: 'assets/3.png',
      displayLetter: 'Р',
      type: CityType.ancient,
    ),
    City(
      id: 4,
      title: 'Костромской Ипатьевский монастырь',
      description: 'Знаменитая «колыбель» династии Романовых. Именно отсюда Михаил Федорович был призван на российский престол.',
      cityName: 'Кострома',
      assetPath: 'assets/4.png',
      displayLetter: 'К',
      type: CityType.cultural,
    ),
    City(
      id: 5,
      title: 'Волжская набережная и Стрелка',
      description: 'Столица Золотого кольца с тысячелетней историей. Место слияния Волги и Которосли, украшенное фонтанами и старинными храмами.',
      cityName: 'Ярославль',
      assetPath: 'assets/5.png',
      displayLetter: 'Я',
      type: CityType.cultural,
    ),
    City(
      id: 6,
      title: 'Торговые ряды и Суздальский Кремль',
      description: 'Город-музей под открытым небом, где полностью сохранился дух древней Руси. Славится деревянным зодчеством и медовухой.',
      cityName: 'Суздаль',
      assetPath: 'assets/6.png',
      displayLetter: 'С',
      type: CityType.ancient,
    ),
    City(
      id: 7,
      title: 'Золотые ворота и Успенский собор',
      description: 'Уникальный памятник древнерусской фортификационной архитектуры XII века и величественный собор, где венчались на княжение великие князья.',
      cityName: 'Владимир',
      assetPath: 'assets/7.png',
      displayLetter: 'В',
      type: CityType.cultural,
    ),
    City(
      id: 8,
      title: 'Ивановские ситцы и Музей ивановского ситца',
      description: 'Самый молодой город маршрута, известный своей текстильной промышленностью, уникальной архитектурой конструктивизма и «городом невест».',
      cityName: 'Иваново',
      assetPath: 'assets/8.png',
      displayLetter: 'И',
      type: CityType.industrial,
    ),
  ];

  void _toggleLike(int cityId) {
    setState(() {
      if (_likedCityIds.contains(cityId)) {
        _likedCityIds.remove(cityId);
      } else {
        _likedCityIds.add(cityId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<City> visibleCities = _onlyFavorites
        ? _allCities.where((city) => _likedCityIds.contains(city.id)).toList()
        : _allCities;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text(
          'Золотое кольцо России',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 2,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'В каталоге: ${_allCities.length}  ·  В избранном: ${_likedCityIds.length}',
                  style: const TextStyle(
                    fontSize: 14, 
                    color: Colors.grey, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _onlyFavorites = !_onlyFavorites;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _onlyFavorites ? Colors.orange.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _onlyFavorites ? Colors.orange : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 16,
                          color: _onlyFavorites ? Colors.orange.shade800 : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Мое избранное',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _onlyFavorites ? Colors.orange.shade900 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: visibleCities.isEmpty
                ? const Center(
                    child: Text(
                      'Ничего не нашлось',
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: visibleCities.length,
                    itemBuilder: (context, index) {
                      final city = visibleCities[index];
                      return CityCard(
                        city: city,
                        isLiked: _likedCityIds.contains(city.id),
                        onLikeTap: () => _toggleLike(city.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
