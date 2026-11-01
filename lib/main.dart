import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'hw2/login_screen.dart';
import 'ui/screens/catalog_screen.dart';
import 'bloc/books_bloc.dart';
import 'bloc/books_event.dart';
import 'data/books_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.data == null) {
            return const LoginScreen();
          }
          return BlocProvider(
            create: (_) {
              final bloc = BooksBloc(BooksRepository());
              print('Создаём BooksBloc');
              print('UID пользователя: ${snapshot.data!.uid}');
              
              bloc.add(UidUpdated(snapshot.data!.uid));
              print('Отправлено UidUpdated');
              
              bloc.add(BooksLoadRequested());
              print('Отправлено BooksLoadRequested');
              
              return bloc;
            },
            child: const CatalogScreen(),
          );
        },
      ),
    );
  }
}