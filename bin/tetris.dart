void main() {
  var playField = PlayField(10, 24);
  var O = Tetromino([1, 1, 1, 1], width: 2);
  var T = Tetromino([0, 1, 0, 1, 1, 1], width: 3);
  var test = Tetromino([0, 1, 2, 3, 4, 5], width: 3);

  // 0, 1, 0, 1, 1, 1
  // 1, 0, 1, 1, 1, 0
  // 1, 1, 1, 0, 1, 0
  // 0, 1, 1, 1, 0, 1
  //
  // print(T);
  // T.rotateClockwise();
  // print(T);
  // T.rotateClockwise();
  // print(T);
  // T.rotateClockwise();
  // print(T);
  // T.rotateCounter();
  // print(T);
  // T.rotateCounter();
  // print(T);
  // T.rotateCounter();
  // print(T);

  print(playField);
  print("");

  playField.add(T);
  print(playField);
  print("");

  playField.moveLeft();
  print(playField);
  print("");

  playField.moveLeft();
  print(playField);
  print("");

  playField.moveLeft();
  print(playField);
  print("");

  playField.moveLeft();
  print(playField);
  print("");

  playField.moveLeft();
  print(playField);
  print("");

  playField.add(O);
  print(playField);
  print("");

  playField.moveLeft();
  print(playField);
  print("");

  playField.moveLeft();
  print(playField);
  print("");
}

class PlayField {
  final int width;
  final int height;
  final List<int> array;
  final int start;
  Tetromino _current;
  int _currentIndex;
  List<int> _currentIndexList;

  PlayField(this.width, this.height, {int start = 0})
      : array = List.filled(width * height, 0),
        start = width ~/ 2;

  void add(Tetromino tetromino) {
    _current = tetromino;
    _currentIndexList = List(_current.array.length);
    _currentIndex = start;
    setCurrent(_currentIndex);
  }

  List<int> createNewIndexList(int index) {
    var newIndexList = List<int>(_currentIndexList.length);
    for (int i = 0; i < newIndexList.length; i++) {
      var newIndex = index +
          (i % _current.displayWidth) +
          (i ~/ _current.displayWidth * width) -
          _current.topCenter;
      newIndexList[i] = newIndex;
    }
    return newIndexList;
  }

  void setCurrent(int index) {
    var newIndexList = createNewIndexList(index);
    _currentIndexList = newIndexList;
    for (int i = 0; i < _currentIndexList.length; i++) {
      set(_currentIndexList[i], _current.array[i]);
    }
  }

  void unsetCurrent() {
    for (int i = 0; i < _currentIndexList.length; i++) {
      unset(_currentIndexList[i]);
    }
  }

  int newPosRight(int index) {
    return index + _current.displayWidth - 1 - _current.topCenter;
  }

  bool checkCollide(int index) {
    var newIndexList = createNewIndexList(index);
    var overlap = List.from(newIndexList);
    overlap.removeWhere((index) => _currentIndexList.contains(index));
    for (int i = 0; i < overlap.length; i++) {
      var newIndex = overlap[i];
      if (array[newIndex] + _current.display[i] > 1) {
        return true;
      }
    }
    return false;
  }

  void moveRight() {
    var newIndex = _currentIndex + 1;
    if (newIndex ~/ width == newPosRight(newIndex) ~/ width &&
        newPosRight(newIndex) < array.length &&
        !checkCollide(newIndex)) {
      unsetCurrent();
      _currentIndex = newIndex;
      setCurrent(_currentIndex);
    } else {
      print("Collided!");
    }
  }

  int newPosLeft(int index) {
    return index - _current.displayWidth + 1 + _current.topCenter;
  }

  void moveLeft() {
    var newIndex = _currentIndex - 1;
    if (newIndex ~/ width == newPosLeft(newIndex) ~/ width &&
        newPosLeft(newIndex) >= 0 &&
        !checkCollide(newIndex)) {
      unsetCurrent();
      _currentIndex = newIndex;
      setCurrent(_currentIndex);
    } else {
      print("Collided!");
    }
  }

  void set(int index, int bit) {
    array[index] += bit;
  }

  void unset(int index) {
    array[index] = 0;
  }

  @override
  String toString() {
    var buffer = StringBuffer();
    for (int i = 0; i < array.length; i++) {
      buffer.write(array[i]);
      buffer.write(" ");
      if ((i + 1) % width == 0) buffer.writeln();
    }
    return buffer.toString();
  }
}

class Tetromino {
  final List<int> array;
  final int width;
  final int height;
  int _rotation = 0;
  List<int> _display;
  int _displayWidth;
  int _displayHeight;

  Tetromino(this.array, {int width, int height})
      : assert(width != null || height != null),
        width = width ?? (array.length ~/ height),
        height = height ?? (array.length ~/ width) {
    _display = this.array;
    _displayWidth = this.width;
    _displayHeight = this.height;
  }

  List<int> get display => List.unmodifiable(_display);

  int get displayWidth => _displayWidth;

  int get displayHeight => _displayHeight;

  int get topCenter => _displayWidth ~/ 2;

  int clockwiseFormula(int i) {
    return (i % _displayWidth + 1) * _displayHeight - (i ~/ _displayWidth + 1);
  }

  int counterFormula(int i) {
    return _display.length - 1 - clockwiseFormula(i);
  }

  void rotateClockwise() {
    _rotation = (_rotation + 90) % 360;
    var newArray = List<int>(_display.length);
    for (int i = 0; i < newArray.length; i++) {
      newArray[clockwiseFormula(i)] = _display[i];
    }
    var oldHeight = _displayHeight;
    _displayHeight = _displayWidth;
    _displayWidth = oldHeight;

    _display = newArray;
  }

  void rotateCounter() {
    _rotation = (_rotation - 90).abs() % 360;
    var newArray = List<int>(_display.length);
    for (int i = 0; i < newArray.length; i++) {
      newArray[counterFormula(i)] = _display[i];
    }
    var oldHeight = _displayHeight;
    _displayHeight = _displayWidth;
    _displayWidth = oldHeight;

    _display = newArray;
  }

  @override
  String toString() {
    var buffer = StringBuffer();
    for (int i = 0; i < _display.length; i++) {
      buffer.write(_display[i]);
      buffer.write(" ");
      if ((i + 1) % _displayWidth == 0) buffer.writeln();
    }
    return buffer.toString();
  }
}
