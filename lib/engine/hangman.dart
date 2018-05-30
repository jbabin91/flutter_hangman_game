import 'dart:async';

class HangmanGame {
  // Number of wrong guesses before the player's demise
  static const int hanged = 7;
  // List of possible words to guess
  final List<String> wordList;
  final Set<String> lettersGuessed = new Set<String>();

  List<String> _wordToGuess;
  int _wrongGuesses;

  StreamController<Null> _onWin = new StreamController<Null>.broadcast();
  Stream<Null> get onWin => _onWin.stream;

  StreamController<Null> _onLose = new StreamController<Null>.broadcast();
  Stream<Null> get onLose => _onLose.stream;

  StreamController<int> _onWrong = new StreamController<int>.broadcast();
  Stream<int> get onWrong => _onWrong.stream;

  StreamController<String> _onRight = new StreamController<String>.broadcast();
  Stream<String> get onRight => _onRight.stream;

  StreamController<String> _onChange = new StreamController<String>.broadcast();
  Stream<String> get onChange => _onRight.stream;

  HangmanGame(List<String> words) : wordList = new List<String>.from(words);

  int get wrongGuesses => _wrongGuesses;
  List<String> get wordToGuess => _wordToGuess;
  String get fullWord => wordToGuess.join();

  String get wordForDisplay => wordToGuess
      .map((String letter) => lettersGuessed.contains(letter) ? letter : "_")
      .join();

  // Check to see if every letter in the word has been guessed
  bool get isWordComplete {
    for (String letter in _wordToGuess) {
      if (!lettersGuessed.contains(letter)) {
        return false;
      }
    }
    return true;
  }

  void newGame() {
    // Shuffle the word list into a random order
    wordList.shuffle();

    // Break the first word from the shuffled list into a list of letters
    _wordToGuess = wordList.first.split('');

    // Reset the wrong guess count
    _wrongGuesses = 0;

    // Clear the set of guessed letters
    lettersGuessed.clear();

    // Declare the change (new word)
    _onChange.add(wordForDisplay);
  }

  void guessLetter(String letter) {
    // Store guessed letter
    lettersGuessed.add(letter);

    // If the guessed letter is present in the word, check for a win
    // otherwise, check for player death
    if (_wordToGuess.contains(letter)) {
      _onRight.add(letter);
      if (isWordComplete) {
        _onChange.add(fullWord);
        _onWin.add(null);
      } else {
        _onChange.add(wordForDisplay);
      }
    } else {
      _wrongGuesses++;

      _onWrong.add(_wrongGuesses);

      if (_wrongGuesses == hanged) {
        _onChange.add(fullWord);
        _onLose.add(null);
      }
    }
  }
}
