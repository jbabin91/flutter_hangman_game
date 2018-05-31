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
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('Hangman'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new Image.asset(_activeImage),
            ),
            new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Center(
                child: new Text(
                  _activeWord,
                  style: activeWordStyle,
                ),
              ),
            ),
            new Expanded(
              child: new Center(
                child: this._renderBottomContent(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderBottomContent() {
    if (_showNewGame) {
      return new RaisedButton(
        child: new Text('New Game'),
        onPressed: this._newGame,
      );
    } else {
      final Set<String> lettersGuessed = widget._engine.lettersGuessed;

      return new Wrap(
        spacing: 1.0,
        runSpacing: 1.0,
        alignment: WrapAlignment.center,
        children: alphabet
            .map((letter) => new MaterialButton(
                  child: new Text(letter),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: lettersGuessed.contains(letter)
                      ? null
                      : () {
                          widget._engine.guessLetter(letter);
                        },
                ))
            .toList(),
      );
    }
  }
}
