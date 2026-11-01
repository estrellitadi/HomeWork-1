import 'package:flutter/material.dart';
import '../../domain/entities/city.dart';

class CityCard extends StatelessWidget {
  final City city;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onTap;

  const CityCard({
    super.key,
    required this.city,
    required this.isLiked,
    this.onLikeTap,
    this.onTap,
  });

  IconData _getCategoryIcon(CityType type) {
    switch (type) {
      case CityType.ancient:
        return Icons.account_balance;
      case CityType.cultural:
        return Icons.museum;
      case CityType.industrial:
        return Icons.factory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    city.displayLetter,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      city.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.orange.shade700),
                        const SizedBox(width: 2),
                        Text(city.cityName, style: TextStyle(fontSize: 12, color: Colors.orange.shade700)),
                        const SizedBox(width: 8),
                        Icon(_getCategoryIcon(city.type), size: 14, color: Colors.grey.shade600),
                      ],
                    ),
                  ],
                ),
              ),
              
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                onPressed: onLikeTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}