import 'package:flutter/material.dart';

void main() {
  runApp(const HW1App());
}

class HW1App extends StatelessWidget {
  const HW1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Дивидишка'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              task1(),
              const SizedBox(height: 16),
              task2(),
              const SizedBox(height: 16),
              task3(),
              const SizedBox(height: 16),
              task4(),
              const SizedBox(height: 16),
              task5(),
              const SizedBox(height: 16),
              task6(),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Заголовок
Widget task1() {
  return const Text(
    'Путешествия',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}


Widget task2() {
  return Container(
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.grey[850],
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: const Text(
      'Всем привет! Меня зовут Диана Сагадеева и вы попали в мое пространство. Оставайся со мной, будет увлекательно! ',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    ),
  );
}

Widget task3() {
  return const Icon(
    Icons.star,
    color: Colors.amber,
    size: 48.0,
  );
}

Widget task4() {
  return IconButton(
    iconSize: 48.0,
    icon: const Icon(
      Icons.favorite,
      color: Colors.red,
    ),
    onPressed: () {
      print('Вы добавили в избранное');
    },
  );
}

Widget task5() {
  return OutlinedButton(
    onPressed: () {
      print('Узнать детали');
    },
    child: const Text('Подробнее'),
  );
}


Widget task6() {
  return Center(
    child: Container(
      width: 300, 
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
      child: Image.network(
        'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=500',
        height: 268,
        fit: BoxFit.cover,
      ),
    ),
  );
}