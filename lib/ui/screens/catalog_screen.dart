import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/city.dart';
import '../widgets/city_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final String _baseUrl = 'https://6ad49bd348476c0785d92770.mockapi.io';

  List<City> _cities = [];
  bool _isLoading = false;
  String? _error;

  final Set<String> _likedCityIds = <String>{};
  bool _onlyFavorites = false;

  bool _showForm = false;
  
  final _titleController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(Uri.parse('$_baseUrl/cities'));

      if (response.statusCode != 200) {
        throw Exception('Статус сервера: ${response.statusCode}');
      }

      final list = jsonDecode(response.body) as List;
      setState(() {
        _cities = list.map((e) => City.fromJson(e as Map<String, dynamic>)).toList();
      });
    } catch (e) {
      setState(() {
        _error = 'Не удалось загрузить данные. Проверьте подключение к интернету.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addCity() async {
    final titleText = _titleController.text.trim();
    final cityText = _cityController.text.trim();
    final descText = _descriptionController.text.trim();
    
    if (titleText.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

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

      final response = await http.post(
        Uri.parse('$_baseUrl/cities'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(newCity.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
      final createdCity = City.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      
      setState(() {
        _cities.insert(0, createdCity);
        _titleController.clear();
        _cityController.clear();
        _descriptionController.clear();
        _showForm = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Успешно сохранено на сервере MockAPI!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отправки: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    final List<City> visibleCities = _onlyFavorites
    ? _cities.where((city) => city.id != null && _likedCityIds.contains(city.id!)).toList()
    : _cities;

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
            icon: Icon(_showForm ? Icons.close : Icons.add, color: Colors.white),
            onPressed: () {
              setState(() {
                _showForm = !_showForm;
              });
            },
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
                    decoration: const InputDecoration(
                      labelText: 'Название достопримечательности',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'В каком городе находится?',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Краткое описание достопримечательности',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addCity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, 
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Отправить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'В каталоге: ${_cities.length}  ·  В избранном: ${_likedCityIds.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _onlyFavorites = !_onlyFavorites;
                    });
                  },
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
            child: _buildMainContent(visibleCities),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(List<City> visibleCities) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 14)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadCatalog,
              child: const Text('Обновить'),
            ),
          ],
        ),
      );
    }

    if (visibleCities.isEmpty) {
      return const Center(
        child: Text('Ничего не нашлось', style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: visibleCities.length,
      itemBuilder: (context, index) {
        final city = visibleCities[index];
        return CityCard(
          city: city,
          isLiked: city.id != null && _likedCityIds.contains(city.id!),
          onLikeTap: () => city.id != null ? _toggleLike(city.id!) : null,
          );
      },
    );
  }
}
