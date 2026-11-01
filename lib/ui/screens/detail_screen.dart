import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/city.dart';
import '../../bloc/books_bloc.dart';
import '../../bloc/books_event.dart';
import '../../bloc/books_state.dart';

class DetailScreen extends StatelessWidget {
  final City city;
  final BooksBloc booksBloc; 

  const DetailScreen({
    super.key, 
    required this.city,
    required this.booksBloc, 
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: booksBloc, 
      child: _DetailScreenContent(city: city),
    );
  }
}

class _DetailScreenContent extends StatelessWidget {
  final City city;
  const _DetailScreenContent({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: Text(city.title),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Удалить?'),
                  content: Text('Удалить "${city.title}" из каталога?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BooksBloc>().add(CityDeleted(city.id));
                        Navigator.pop(context); 
                        Navigator.pop(context); 
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Удалить', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          final isLiked = state is BooksLoadSuccess && state.favorites.contains(city.id);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      city.displayLetter,
                      style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Text(
                  city.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 4),
                    Text(city.cityName, style: TextStyle(color: Colors.orange.shade700, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(Icons.category, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 4),
                    Text(city.type.name, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.read<BooksBloc>().add(FavoriteToggled(city.id)),
                    icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                    label: Text(isLiked ? 'В избранном' : 'Добавить в избранное'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLiked ? Colors.red.shade50 : Colors.white,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Описание',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  city.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}