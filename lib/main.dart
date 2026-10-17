import 'package:flutter/material.dart';
import 'ui/screens/catalog_screen.dart';

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
      home: const CatalogScreen(),
    );
  }
}
