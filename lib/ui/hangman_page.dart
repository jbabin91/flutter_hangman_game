import 'package:flutter/material.dart';
import 'package:hangman/const/global_contants.dart';
import 'package:hangman/engine/hangman.dart';

class HangmanPage extends StatefulWidget {
  final HangmanGame _engine;

  HangmanPage(this._engine);

  @override
  _HangmanPageState createState() => new _HangmanPageState();
}

class _HangmanPageState extends State<HangmanPage> {
  bool _showNewGame;
  String _activeImage;
  String _activeWord;

  @override
  void initState() {
    super.initState();

    widget._engine.onChange.listen(this._updateWordDisplay);
    widget._engine.onWrong.listen(this._updateGallowsImage);
    widget._engine.onWin.listen(this._win);
    widget._engine.onLose.listen(this._gameOver);

    this._newGame();
  }

  void _newGame() {
    widget._engine.newGame();

    this.setState(() {
      _activeWord = '';
      _activeImage = progressImages[0];
      _showNewGame = false;
    });
  }

  void _updateWordDisplay(String word) {
    this.setState(() {
      _activeWord = word;
    });
  }

  void _updateGallowsImage(int wrongGuessCount) {
    this.setState(() {
      _activeImage = progressImages[wrongGuessCount];
    });
  }

  void _win([_]) {
    this.setState(() {
      _activeImage = victoryImage;
      this._gameOver();
    });
  }

  void _gameOver([_]) {
    this.setState(() {
      _showNewGame = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
