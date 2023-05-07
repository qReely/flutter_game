import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

class WordlePage extends StatefulWidget {
  const WordlePage({Key? key}) : super(key: key);

  @override
  State<WordlePage> createState() => _WordlePageState();
}

// TODO - GET WORD FROM DICT
// TODO - BUILD PAGE
// TODO - BUILD LOGIC -> ENTER A WORD, THAT IS INSIDE DICT

class _WordlePageState extends State<WordlePage> {
  String dictUrl = "https://gist.githubusercontent.com/scholtes/94f3c0303ba6a7768b47583aff36654d/raw/d9cddf5e16140df9e14f19c2de76a0ef36fd2748/wordle-La.txt";
  List<String> dict = [];
  String wordToGuess = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDict();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wordle"),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: Column(

      ),
    );
  }

  Future loadDict() async {
    var response = await http.get(Uri.parse(dictUrl));
    if (response.statusCode == 200) {
      dict = response.body.split("\n");
      getWordToGuess();
      print(wordToGuess);
    } else {
      dict = [];
    }
  }

  void getWordToGuess(){
    wordToGuess = dict.elementAt(Random.secure().nextInt(dict.length));
  }
}
