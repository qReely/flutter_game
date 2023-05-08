import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/palette.dart';

import 'game_model.dart';

class WordleGame extends StatelessWidget{
  GameModel model;

  WordleGame({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Correct word was: ${model.wordToGuess}"),
        centerTitle: true,
        backgroundColor: Palette.main,
        toolbarHeight: 60,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: model.guessedWords
                .map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: e
                  .map((e) => Container(
                padding: const EdgeInsets.all(16),
                width: 64,
                height: 64,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: e.code.name == 'blank' ? Palette.blank
                        : e.code.name == 'none' ? Palette.none
                        : e.code.name == 'exists' ? Palette.exists
                        : Palette.correct),
                child: Center(
                  child: Text(e.letter!, style: const TextStyle(color: Colors.white),),
                ),
              ))
                  .toList(),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}