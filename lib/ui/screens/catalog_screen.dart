import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/city.dart';
import '../../bloc/books_bloc.dart';
import '../../bloc/books_state.dart';
import '../../bloc/books_event.dart';
import '../widgets/city_card.dart';
import 'detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _titleController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
  final booksBloc = context.read<BooksBloc>(); 
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Новая достопримечательность'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Название *'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(labelText: 'Город'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Описание'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _titleController.clear();
            _cityController.clear();
            _descriptionController.clear();
            Navigator.pop(dialogContext);
          },
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final titleText = _titleController.text.trim();
            final cityText = _cityController.text.trim();
            final descText = _descriptionController.text.trim();
            
            if (titleText.isEmpty) return;
            
            final newCity = City(
              id: '',
              title: titleText,
              description: descText.isNotEmpty ? descText : 'Новая достопримечательность маршрута.',
              cityName: cityText.isNotEmpty ? cityText : 'Новый город',
              assetPath: 'assets/new_location.png', 
              displayLetter: titleText.substring(0, 1).toUpperCase(),
              type: CityType.ancient,
            );
            
            booksBloc.add(CityAdded(newCity));
            
            _titleController.clear();
            _cityController.clear();
            _descriptionController.clear();
            Navigator.pop(dialogContext);
          },
          child: const Text('Добавить'),
        ),
      ],
    ),
  );
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
            onPressed: _showAddDialog,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск по названию',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (query) {
                context.read<BooksBloc>().add(SearchChanged(query));
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<BooksBloc, BooksState>(
              builder: (context, state) {
                if (state is BooksLoadInProgress) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }
                
                if (state is BooksLoadFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 16)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            context.read<BooksBloc>().add(BooksLoadRequested());
                          },
                          child: const Text('Обновить'),
                        ),
                      ],
                    ),
                  );
                }

                final successState = state as BooksLoadSuccess;
                final visibleCities = successState.visibleCities;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'В каталоге: ${successState.cities.length}  ·  Показано: ${visibleCities.length}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () => context.read<BooksBloc>().add(FilterToggled()),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: successState.onlyFavorites ? Colors.orange.shade100 : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: successState.onlyFavorites ? Colors.orange : Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.favorite, size: 14, color: successState.onlyFavorites ? Colors.orange.shade800 : Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Только избранные',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: successState.onlyFavorites ? Colors.orange.shade900 : Colors.grey.shade700),
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
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    successState.onlyFavorites 
                                        ? 'В избранном пока пусто' 
                                        : successState.searchQuery.isNotEmpty 
                                            ? 'Ничего не найдено' 
                                            : 'Каталог пуст',
                                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              itemCount: visibleCities.length,
                              itemBuilder: (context, index) {
                                final city = visibleCities[index];
                                return CityCard(
                                  city: city,
                                  isLiked: successState.favorites.contains(city.id),
                                  onLikeTap: () => context.read<BooksBloc>().add(FavoriteToggled(city.id)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailScreen(
                                          city: city,
                                          booksBloc: context.read<BooksBloc>()
                                        ),
                                      ),
                                    );
                                  },
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