import 'package:flutter/material.dart';

void main() {
  runApp(const GoldenRingApp());
}

class GoldenRingApp extends StatelessWidget {
  const GoldenRingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Золотое кольцо России',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const GoldenRingScreen(),
    );
  }
}

class CityItem {
  final String title;
  final String description;
  final String cityName;
  final String assetPath; 
  final String displayLetter;

  const CityItem({
    required this.title,
    required this.description,
    required this.cityName,
    required this.assetPath,
    required this.displayLetter,
  });
}

class GoldenRingScreen extends StatelessWidget {
  const GoldenRingScreen({super.key});

  final List<CityItem> cities = const [
    CityItem(
      title: 'Свято-Троицкая Сергиева Лавра',
      description: 'Крупнейший мужской монастырь Русской православной церкви с многовековой историей. Основан преподобным Сергием Радонежским.',
      cityName: 'Сергиев Посад',
      assetPath: 'assets/1.png',
      displayLetter: 'С',
    ),
    CityItem(
      title: 'Переславский Кремль и Спасо-Преображенский собор',
      description: 'Древнейший белокаменный храм Руси, заложенный Юрием Долгоруким. Город на берегу живописного Плещеева озера.',
      cityName: 'Переславль-Залесский',
      assetPath: 'assets/2.png',
      displayLetter: 'П',
    ),
    CityItem(
      title: 'Ростовский Кремль (Митрополичий двор)',
      description: 'Величественная резиденция митрополита с белокаменными стенами и знаменитыми ростовскими звонами. Здесь снимали фильм «Иван Васильевич меняет профессию».',
      cityName: 'Ростов Великий',
      assetPath: 'assets/3.png',
      displayLetter: 'Р',
    ),
    CityItem(
      title: 'Костромской Ипатьевский монастырь',
      description: 'Знаменитая «колыбель» династии Романовых. Именно отсюда Михаил Федорович был призван на российский престол.',
      cityName: 'Кострома',
      assetPath: 'assets/4.png',
      displayLetter: 'К',
    ),
    CityItem(
      title: 'Волжская набережная и Стрелка',
      description: 'Столица Золотого кольца с тысячелетней историей. Место слияния Волги и Которосли, украшенное поющими фонтанами и старинными храмами.',
      cityName: 'Ярославль',
      assetPath: 'assets/5.png',
      displayLetter: 'В',
    ),
    CityItem(
      title: 'Торговые ряды и Суздальский Кремль',
      description: 'Город-музей под открытым небом, где полностью сохранился дух древней Руси. Славится деревянным зодчеством и медовухой.',
      cityName: 'Суздаль',
      assetPath: 'assets/6.png',
      displayLetter: 'Т',
    ),
    CityItem(
      title: 'Золотые ворота и Успенский собор',
      description: 'Уникальный памятник древнерусской фортификационной архитектуры XII века и величественный собор, где венчались на княжение великие князья.',
      cityName: 'Владимир',
      assetPath: 'assets/7.png',
      displayLetter: 'З',
    ),
    CityItem(
      title: 'Ивановские ситцы и Дом-музей Бубнова',
      description: 'Самый молодой город маршрута, известный своей текстильной промышленностью, уникальной архитектурой конструктивизма.',
      cityName: 'Иваново',
      assetPath: 'assets/8.png',
      displayLetter: 'И',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text(
          'Золотое кольцо России',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 224, 133, 22), 
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          city.assetPath,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.orange.shade200,
                              child: const Icon(Icons.image, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            city.displayLetter,
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 6.0,
                                  color: Colors.black54,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          city.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                city.cityName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
