import 'package:hive/hive.dart';

part 'letter.g.dart';

@HiveType(typeId: 2, adapterName: 'LetterGuessAdapter')
enum LetterGuess {
  @HiveField(0)
  blank,
  @HiveField(1)
  none,
  @HiveField(2)
  exists,
  @HiveField(3)
  correct
}

@HiveType(typeId: 1, adapterName: 'LetterAdapter')
class Letter {
  @HiveField(0)
  String? letter;
  @HiveField(1)
  LetterGuess code;

  Letter(this.letter, this.code);
}
