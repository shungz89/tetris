import 'dart:math';

import 'package:tetris/model/tetromino.dart';

class PlayField {
  final int width;
  final int height;
  final List<int> array;
  final List<Tetromino> tetrominos;
  final int start;
  Random _rng = Random();
  Tetromino _current;
  int _currentIndex;
  List<int> _currentIndexList;

  PlayField(this.width, this.height,
      {int start = 0, this.tetrominos = const []})
      : array = List.filled(width * height, 0),
        start = width ~/ 2;

  Tetromino get random => tetrominos[_rng.nextInt(tetrominos.length)];

  bool _add(Tetromino tetromino) {
    _current = tetromino;
    _currentIndexList = List(_current.display.length);
    _currentIndex = start;
    return _setCurrent(_currentIndex);
  }

  void reset() {
    _current = null;
    array.fillRange(0, array.length, 0);
  }

  bool proceed() {
    if (_current == null || !moveDown()) {
      if (!_add(random)) {
        print("Game Over!");
        _current = null;
        return false;
      }
    }
    print(this);
    return true;
  }

  List<int> _createNewIndexList(int index) {
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

  bool _setCurrent(int index) {
    var newIndexList = _createNewIndexList(index);
    _currentIndexList = newIndexList;
    for (int i = 0; i < _currentIndexList.length; i++) {
      var value = _set(_currentIndexList[i], _current.display[i]);
      if (value > 1) return false;
    }
    return true;
  }

  void _unsetCurrent() {
    for (int i = 0; i < _currentIndexList.length; i++) {
      _unset(_currentIndexList[i]);
    }
  }

  int _calcPosRight(int index) {
    return index + _current.displayWidth - 1 - _current.topCenter;
  }

  int _calcPosLeft(int index) {
    return index - _current.displayWidth + _current.displayWidth - _current.topCenter;
  }

  int calcPosDown(int index) {
    return index + width * (_current.displayHeight - 1);
  }

  bool _checkCollide(int index) {
    var newIndexList = _createNewIndexList(index);
    var nextIndexList = List.from(newIndexList);
    for (int i = 0; i < newIndexList.length; i++) {
      var newIndex = nextIndexList[i];
      if (_currentIndexList.contains(newIndex)) continue;
      if (array[newIndex] + _current.display[i] > 1) {
        return true;
      }
    }
    return false;
  }

  bool _checkBeforeRightBoundary(int index) {
    return _calcPosRight(index) ~/ width == _calcPosRight(_currentIndex) ~/ width &&
        _calcPosRight(index) < array.length;
  }

  bool _checkBeforeLeftBoundary(int index) {
    print(_calcPosLeft(index));
    print(_calcPosLeft(_currentIndex));
    return _calcPosLeft(index) ~/ width == _calcPosLeft(_currentIndex) ~/ width &&
        _calcPosLeft(index) >= 0;
  }

  bool _checkBeforeBottom(int index) {
    return calcPosDown(index) < array.length;
  }

  bool moveRight() {
    if (_current == null) return false;
    var newIndex = _currentIndex + 1;
    if (_checkBeforeRightBoundary(newIndex) && !_checkCollide(newIndex)) {
      _unsetCurrent();
      _currentIndex = newIndex;
      _setCurrent(_currentIndex);
      return true;
    } else {
      print("Collided!");
      return false;
    }
  }

  void rotateLeft() {
    if (_current == null) return;
    _unsetCurrent();
    _current.rotateCounter();
    _setCurrent(_currentIndex);
  }

  void rotateRight() {
    if (_current == null) return;
    _unsetCurrent();
    _current.rotateClockwise();
    _setCurrent(_currentIndex);
  }

  bool moveLeft() {
    if (_current == null) return false;
    var newIndex = _currentIndex - 1;
    if (_checkBeforeLeftBoundary(newIndex) && !_checkCollide(newIndex)) {
      _unsetCurrent();
      _currentIndex = newIndex;
      _setCurrent(_currentIndex);
      return true;
    } else {
      print("Collided!");
      return false;
    }
  }

  bool moveDown() {
    if (_current == null) return false;
    var newIndex = _currentIndex + width;
    if (_checkBeforeBottom(newIndex) && !_checkCollide(newIndex)) {
      _unsetCurrent();
      _currentIndex = newIndex;
      _setCurrent(_currentIndex);
      return true;
    } else {
      print("Collided!");
      return false;
    }
  }

  int _set(int index, int bit) {
    array[index] += bit;
    return array[index];
  }

  void _unset(int index) {
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
