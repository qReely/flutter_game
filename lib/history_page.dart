import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/game_model.dart';
import 'package:flutter_game/palette.dart';
import 'package:flutter_game/wordle_game.dart';
import 'package:hive/hive.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final box = Hive.box('wordle');
  int length = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    length = box.length - 2;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
        toolbarHeight: 60,
        // foregroundColor: Palette.main,
        backgroundColor: Palette.main,
      ),
      body: length == 0 ?
          Center(
            child: Text(
              "No Games Played",
              style: TextStyle(color: Palette.blank, fontSize: 24),
            )
          ) :
      ListView.builder(
        itemCount: length,
        itemBuilder: (context, index) {
          int pos = length - index;
          GameModel model = GameModel.fromJson(box.get(pos - 1));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text("Game #$pos"),
              tileColor: model.isWin ? Palette.gameWon : Palette.gameLost,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WordleGame(model: model))),
            ),
          );
        },
      ),
    );
  }
}
