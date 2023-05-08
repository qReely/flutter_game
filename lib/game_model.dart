import 'letter.dart';

class GameModel {
  String wordToGuess;
  List<List<Letter>> guessedWords;
  bool isWin;

  GameModel(
      {required this.wordToGuess,
      required this.guessedWords,
      required this.isWin});

  static GameModel fromJson(Map<dynamic, dynamic> json) {
    return GameModel(
        wordToGuess : json['wordToGuess'].toString(),
        guessedWords : getList(json['guessedWords']),
        isWin : json['isWin'],
    );
  }

  static List<List<Letter>> getList(List<dynamic> list){
    List<List<Letter>> output = [[],[],[],[],[]];
    for(int i = 0; i < 5; i++){
      output[i] = List<Letter>.from(list[i]);
    }

    return output;
  }
}
