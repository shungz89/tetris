void main() {
  var playField = PlayField(10, 24);
  var O = Tetromino([1, 1, 1, 1], width: 2);
  var T = Tetromino([0, 1, 0, 1, 1, 1], width: 3);
  var test = Tetromino([0, 1, 2, 3, 4, 5], width: 3);

  // 0, 1, 0, 1, 1, 1
  // 1, 0, 1, 1, 1, 0
  // 1, 1, 1, 0, 1, 0
  // 0, 1, 1, 1, 0, 1

  print(T);
  T.rotateClockwise();
  print(T);
  T.rotateClockwise();
  print(T);
  T.rotateClockwise();
  print(T);
  T.rotateCounter();
  print(T);
  T.rotateCounter();
  print(T);
  T.rotateCounter();
  print(T);

  // print(playField);
  // playField.add(T);
  // print("");
  // print(playField);
}

class Coord {
  final int x, y;

  const Coord(this.x, this.y);

  Coord operator +(Coord other) {
    return Coord(this.x + other.x, this.y + other.y);
  }

  @override
  String toString() {
    return "($x, $y)";
  }
}

class PlayField {
  final int width;
  final int height;
  final List<int> array;
  final Coord start;
  Tetromino _current;
  Coord _currentCoord;

  PlayField(this.width, this.height, {Coord start = const Coord(0, 0)})
      : array = List.filled(width * height, 0),
        start = Coord(0, width ~/ 2);

  void add(Tetromino tetromino) {
    _current = tetromino;
    _currentCoord = start;
    for (int i = 0; i < _current.array.length; i++) {
      var tetCoord = _current.indexToCoord(i);
      var localCoord = tetCoord + _currentCoord;
      set(localCoord, _current.array[i]);
    }
  }

  int coordToIndex(Coord coord) {
    return coord.x * width + coord.y;
  }

  void set(Coord coord, int bit) {
    array[coordToIndex(coord)] = bit;
  }

  void unset(Coord coord) {
    array[coordToIndex(coord)] = 0;
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

  Coord indexToCoord(int index) {
    return Coord(index ~/ _displayWidth, index % _displayWidth);
  }

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
