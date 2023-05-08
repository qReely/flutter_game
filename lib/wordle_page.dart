import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/history_page.dart';
import 'package:flutter_game/palette.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'letter.dart';

class WordlePage extends StatefulWidget {
  const WordlePage({Key? key}) : super(key: key);

  @override
  State<WordlePage> createState() => _WordlePageState();

  static GlobalKey<_WordlePageState> createKey() =>
      GlobalKey<_WordlePageState>();
}

class _WordlePageState extends State<WordlePage> {
  final String dictUrl =
      "https://gist.githubusercontent.com/scholtes/94f3c0303ba6a7768b47583aff36654d/raw/d9cddf5e16140df9e14f19c2de76a0ef36fd2748/wordle-La.txt";
  final box = Hive.box('wordle');

  List<String> dict = [];
  String wordToGuess = "";
  String word = "";
  int row = 0;
  int streak = 0;
  bool recordBeaten = false;

  List<List<Letter>> wordsList = List.generate(
      5, (index) => List.generate(5, (index) => Letter("", LetterGuess.blank)));

  List<Letter> kb1 = [];
  List<Letter> kb2 = [];
  List<Letter> kb3 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!box.containsKey("record")) {
      box.put("record", 0);
    }
    if (!box.containsKey("dict")) {
      loadDict();
    } else {
      dict = box.get("dict");
      getWordToGuess();
    }
    setUpKeyboard();
  }

  Future clearBox() async{
    await box.clear();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Wordle"),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: Palette.main,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ),
              );
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 0,
                child: Text("History"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Palette.bckg,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Record: ${box.get("record")}", style: TextStyle(color: Palette.blank, fontSize: 24),),
          Column(
            children: wordsList
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
                                    color: e.code.name == 'blank'
                                        ? Palette.blank
                                        : e.code.name == 'none'
                                            ? Palette.none
                                            : e.code.name == 'exists'
                                                ? Palette.exists
                                                : Palette.correct),
                                child: Center(
                                  child: Text(
                                    e.letter!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ))
                          .toList(),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: kb1.map((e) {
              return GestureDetector(
                onTap: () {
                  addLetter(e.letter.toString());
                },
                child: Container(
                  width: 32,
                  height: 48,
                  // padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: e.code.name == 'blank'
                          ? Palette.blank
                          : e.code.name == 'none'
                              ? Palette.none
                              : e.code.name == 'exists'
                                  ? Palette.exists
                                  : Palette.correct),
                  child: Center(
                    child: Text(
                      "${e.letter}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: kb2.map((e) {
              return GestureDetector(
                onTap: () {
                  addLetter(e.letter.toString());
                },
                child: Container(
                  width: 32,
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: e.code.name == 'blank'
                          ? Palette.blank
                          : e.code.name == 'none'
                              ? Palette.none
                              : e.code.name == 'exists'
                                  ? Palette.exists
                                  : Palette.correct),
                  child: Center(
                    child: Text(
                      "${e.letter}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: kb3.map((e) {
              return GestureDetector(
                onTap: () {
                  e.letter == "DEL"
                      ? removeLetter()
                      : e.letter == "SUB"
                          ? guess()
                          : addLetter(e.letter.toString());
                },
                child: Container(
                    width: 32,
                    height: 48,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: e.code.name == 'blank'
                            ? Palette.blank
                            : e.code.name == 'none'
                                ? Palette.none
                                : e.code.name == 'exists'
                                    ? Palette.exists
                                    : Palette.correct),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Text(
                          "${e.letter}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void setUpKeyboard() {
    kb1 = [];
    kb2 = [];
    kb3 = [];

    for (var letter in "QWERTYUIOP".split("")) {
      kb1.add(Letter(letter, LetterGuess.blank));
    }
    for (var letter in "ASDFGHJKL".split("")) {
      kb2.add(Letter(letter, LetterGuess.blank));
    }
    for (var letter in ["DEL", "Z", "X", "C", "V", "B", "N", "M", "SUB"]) {
      kb3.add(Letter(letter, LetterGuess.blank));
    }
  }

  void reloadApp() {
    setState(() {
      getWordToGuess();
      wordsList = List.generate(
          5,
          (index) =>
              List.generate(5, (index) => Letter("", LetterGuess.blank)));
      word = "";
      row = 0;
      setUpKeyboard();
    });
  }

  Future loadDict() async {
    var response = await http.get(Uri.parse(dictUrl));
    if (response.statusCode == 200) {
      dict = response.body.split("\n");
      box.put("dict", dict);
      getWordToGuess();
    } else {
      throw Future.error("Couldn't load dictionary");
    }
  }

  void getWordToGuess() {
    wordToGuess = dict.elementAt(Random.secure().nextInt(dict.length));
  }

  void addLetter(String letter) {
    if (word.length < 5) {
      setState(() {
        wordsList[row][word.length].letter = letter;
        word += letter;
      });
    }
  }

  void removeLetter() {
    if (word.isNotEmpty) {
      setState(() {
        wordsList[row][word.length - 1].letter = "";
        word = word.substring(0, word.length - 1);
      });
    }
  }

  void guess() {
    setState(() {
      if (row == 5 || word.length != 5) {
        return;
      } else if (!dict.contains(word.toLowerCase())) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Word is not in dictionary")));
        return;
      }
      guessCheck();

      if (word.toLowerCase() == wordToGuess.toLowerCase()) {
        box.add({'wordToGuess' : wordToGuess, 'guessedWords' : wordsList, 'isWin' : true});
        showWinningDialog();
        streak++;
        if (box.get("record") < streak) {
          box.put("record", streak);
          recordBeaten = true;
        }
        return;
      }

      row += 1;
      word = "";
      if (row == 5) {
        box.add({'wordToGuess' : wordToGuess, 'guessedWords' : wordsList, 'isWin' : false});
        showLosingDialog();
        streak = 0;
        recordBeaten = false;
        return;
      }
    });
  }

  void guessCheck() {
    var guessedList = word.toLowerCase().split("");
    var correctWord = wordToGuess.toLowerCase().split("");

    for (var i = 0; i < 5; i++) {
      if (correctWord[i] == guessedList[i]) {
        wordsList[row][i].code = LetterGuess.correct;
        guessedList[i] = "";
        correctWord[i] = "";
      }
    }

    for (var i = 0; i < 5; i++) {
      if (correctWord.contains(guessedList[i]) && guessedList[i] != "") {
        wordsList[row][i].code = LetterGuess.exists;
        correctWord[correctWord.indexOf(guessedList[i])] = "";
        guessedList[i] = "";
      } else if (wordsList[row][i].code == LetterGuess.blank) {
        wordsList[row][i].code = LetterGuess.none;
      }
    }

    recolorKeyboard();
  }

  void recolorKeyboard() {
    for (var letter in wordsList[row]) {
      Letter blankLetter =
          Letter(letter.letter?.toUpperCase(), LetterGuess.blank);
      var idx = kb1.indexWhere((e) =>
          e.letter == blankLetter.letter && e.code.index < letter.code.index);
      if (idx != -1) {
        kb1[idx].code = letter.code;
      }
      idx = kb2.indexWhere((e) =>
          e.letter == blankLetter.letter && e.code.index < letter.code.index);
      if (idx != -1) {
        kb2[idx].code = letter.code;
      }
      idx = kb3.indexWhere((e) =>
          e.letter == blankLetter.letter && e.code.index < letter.code.index);
      if (idx != -1) {
        kb3[idx].code = letter.code;
      }
    }
  }

  void showWinningDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              content: Text(
                  "${recordBeaten ? "New Record!\n" : ""}Current streak: $streak"),
              title: const Text("You won!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    reloadApp();
                  },
                  child: const Text("YAY!"),
                ),
              ],
            ),
          );
        });
  }

  void showLosingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              content: Text("You lost!\nCorrect word was: $wordToGuess"),
              title: const Text("You'll get'em next time!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    reloadApp();
                  },
                  child: const Text("Try again!"),
                ),
              ],
            ),
          );
        });
  }
}
