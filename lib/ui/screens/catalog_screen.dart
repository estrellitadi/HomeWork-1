import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/city.dart';
import '../widgets/city_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _citiesStream = FirebaseFirestore.instance.collection('cities').snapshots();

  final Set<String> _likedCityIds = <String>{};
  bool _onlyFavorites = false;

  bool _showForm = false;
  final _titleController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _seedInitialData(); 
  }

Future<void> _seedInitialData() async {
  final snapshot = await FirebaseFirestore.instance.collection('cities').get();
  
  if (snapshot.docs.isEmpty) {
    final initialCities = [
      {
        'title': 'Свято-Троицкая Сергиева Лавра',
        'description': 'Крупнейший мужской монастырь Русской православной церкви с многовековой историей. Основан преподобным Сергием Радонежским.',
        'cityName': 'Сергиев Посад',
        'assetPath': 'assets/1.png',
        'displayLetter': 'С',
        'type': 'ancient',
      },
      {
        'title': 'Переславский Кремль и Спасо-Преображенский собор',
        'description': 'Древнейший белокаменный храм Руси, заложенный Юрием Долгоруким. Город на берегу живописного Плещеева озера.',
        'cityName': 'Переславль-Залесский',
        'assetPath': 'assets/2.png',
        'displayLetter': 'П',
        'type': 'ancient',
      },
      {
        'title': 'Ростовский Кремль (Митрополичий двор)',
        'description': 'Величественная резиденция митрополита с белокаменными стенами и знаменитыми ростовскими звонами. Здесь снимали фильм «Иван Васильевич меняет профессию».',
        'cityName': 'Ростов Великий',
        'assetPath': 'assets/3.png',
        'displayLetter': 'Р',
        'type': 'ancient',
      },
      {
        'title': 'Костромской Ипатьевский монастырь',
        'description': 'Знаменитая «колыбель» династии Романовых. Именно отсюда Михаил Федорович был призван на российский престол.',
        'cityName': 'Кострома',
        'assetPath': 'assets/4.png',
        'displayLetter': 'К',
        'type': 'ancient',
      },
      {
        'title': 'Волжская набережная и Стрелка',
        'description': 'Столица Золотого кольца с тысячелетней историей. Место слияния Волги и Которосли, украшенное поющими фонтанами и старинными храмами.',
        'cityName': 'Ярославль',
        'assetPath': 'assets/5.png',
        'displayLetter': 'В',
        'type': 'ancient',
      },
      {
        'title': 'Торговые ряды и Суздальский Кремль',
        'description': 'Город-музей под открытым небом, где полностью сохранился дух древней Руси. Славится деревянным зодчеством и медовухой.',
        'cityName': 'Суздаль',
        'assetPath': 'assets/6.png',
        'displayLetter': 'Т',
        'type': 'ancient',
      },
      {
        'title': 'Золотые ворота и Успенский собор',
        'description': 'Уникальный памятник древнерусской фортификационной архитектуры XII века и величественный собор, где венчались на княжение великие князья.',
        'cityName': 'Владимир',
        'assetPath': 'assets/7.png',
        'displayLetter': 'З',
        'type': 'ancient',
      },
      {
        'title': 'Ивановские ситцы и Дом-музей Бубнова',
        'description': 'Самый молодой город маршрута, известный своей текстильной промышленностью, уникальной архитектурой конструктивизма.',
        'cityName': 'Иваново',
        'assetPath': 'assets/8.png',
        'displayLetter': 'И',
        'type': 'industrial',
      },
    ];

    for (final cityData in initialCities) {
      await FirebaseFirestore.instance.collection('cities').add(cityData);
    }
  }
}

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addCity() async {
    final titleText = _titleController.text.trim();
    final cityText = _cityController.text.trim();
    final descText = _descriptionController.text.trim();
    
    if (titleText.isEmpty) return;

    try {
      final newCity = City(
        id: '',
        title: titleText,
        description: descText.isNotEmpty ? descText : 'Новая достопримечательность маршрута.',
        cityName: cityText.isNotEmpty ? cityText : 'Новый город',
        assetPath: 'assets/new_location.png', 
        displayLetter: titleText.substring(0, 1).toUpperCase(),
        type: CityType.ancient,
      );

      await FirebaseFirestore.instance.collection('cities').add(newCity.toJson());
      
      _titleController.clear();
      _cityController.clear();
      _descriptionController.clear();
      setState(() => _showForm = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Успешно сохранено в Firestore!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    }
  }

  void _toggleLike(String cityId) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Выйти из системы'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showForm)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Название', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'Город', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Описание', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addCity,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: const Text('Отправить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: StreamBuilder(
              stream: _citiesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ошибка: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 12),
                        if (snapshot.error.toString().contains('permission-denied'))
                          const Text('Проверь Rules в консоли Firebase!', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;
                final cities = docs.map((doc) => City.fromFirestore(doc)).toList();
                cities.sort((a, b) => a.cityName.compareTo(b.cityName)); 

                final visibleCities = _onlyFavorites
                    ? cities.where((city) => _likedCityIds.contains(city.id)).toList()
                    : cities;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'В каталоге: ${cities.length}  ·  В избранном: ${_likedCityIds.length}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () => setState(() => _onlyFavorites = !_onlyFavorites),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _onlyFavorites ? Colors.orange.shade100 : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _onlyFavorites ? Colors.orange : Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.favorite, size: 14, color: _onlyFavorites ? Colors.orange.shade800 : Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Только избранные',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _onlyFavorites ? Colors.orange.shade900 : Colors.grey.shade700),
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
                          ? const Center(child: Text('Ничего не нашлось', style: TextStyle(fontSize: 16, color: Colors.grey)))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}