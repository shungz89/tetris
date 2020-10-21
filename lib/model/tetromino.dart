class Tetromino {
  final List<int> _array;
  final int _width;
  final int _height;
  int _rotation;
  List<int> _display;
  int _displayWidth;
  int _displayHeight;

  Tetromino(this._array, {int width, int height, int rotation = 0})
      : assert(width != null || height != null),
        _width = width ?? (_array.length ~/ height),
        _height = height ?? (_array.length ~/ width) {
    _rotation = rotation;
    _display = this._array;
    _displayWidth = this._width;
    _displayHeight = this._height;
  }

  List<int> get display => List.unmodifiable(_display);

  int get displayWidth => _displayWidth;

  int get displayHeight => _displayHeight;

  int get topCenter => _displayWidth ~/ 2;

  int get centerLeft => _displayHeight ~/ 2;

  int clockwiseFormula(int i) {
    return (i % _displayWidth + 1) * _displayHeight - (i ~/ _displayWidth + 1);
  }

  int counterFormula(int i) {
    return _display.length - 1 - clockwiseFormula(i);
  }

  Tetromino rotateClockwise() {
    _rotation = (_rotation + 90) % 360;
    var newArray = List<int>(_display.length);
    for (int i = 0; i < newArray.length; i++) {
      newArray[clockwiseFormula(i)] = _display[i];
    }
    var oldHeight = _displayHeight;
    _displayHeight = _displayWidth;
    _displayWidth = oldHeight;

    _display = newArray;
    return this;
  }

  Tetromino rotateCounter() {
    _rotation = (_rotation - 90).abs() % 360;
    var newArray = List<int>(_display.length);
    for (int i = 0; i < newArray.length; i++) {
      newArray[counterFormula(i)] = _display[i];
    }
    var oldHeight = _displayHeight;
    _displayHeight = _displayWidth;
    _displayWidth = oldHeight;

    _display = newArray;
    return this;
  }

  Tetromino clone() {
    return Tetromino(_display, width: _displayWidth, rotation: _rotation);
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
