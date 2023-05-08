// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LetterAdapter extends TypeAdapter<Letter> {
  @override
  final int typeId = 1;

  @override
  Letter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Letter(
      fields[0] as String?,
      fields[1] as LetterGuess,
    );
  }

  @override
  void write(BinaryWriter writer, Letter obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.letter)
      ..writeByte(1)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LetterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LetterGuessAdapter extends TypeAdapter<LetterGuess> {
  @override
  final int typeId = 2;

  @override
  LetterGuess read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LetterGuess.blank;
      case 1:
        return LetterGuess.none;
      case 2:
        return LetterGuess.exists;
      case 3:
        return LetterGuess.correct;
      default:
        return LetterGuess.blank;
    }
  }

  @override
  void write(BinaryWriter writer, LetterGuess obj) {
    switch (obj) {
      case LetterGuess.blank:
        writer.writeByte(0);
        break;
      case LetterGuess.none:
        writer.writeByte(1);
        break;
      case LetterGuess.exists:
        writer.writeByte(2);
        break;
      case LetterGuess.correct:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LetterGuessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
