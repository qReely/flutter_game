import 'package:flutter/material.dart';
import 'package:flutter_game/palette.dart';
import 'package:flutter_game/wordle_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'letter.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(LetterAdapter());
  Hive.registerAdapter(LetterGuessAdapter());
  await Hive.openBox('wordle');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Palette.bckg,
        primaryColor: Palette.main,
        primarySwatch: Colors.blue,
      ),
      home: const WordlePage(),
    );
  }
}