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

  void _add(Tetromino tetromino) {
    _current = tetromino;
    _currentIndexList = List(_current.array.length);
    _currentIndex = start;
    _setCurrent(_currentIndex);
  }

  void proceed() {
    if (_current == null || !moveDown()) {
      _add(random);
    }
    print(this);
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

  void _setCurrent(int index) {
    var newIndexList = _createNewIndexList(index);
    _currentIndexList = newIndexList;
    for (int i = 0; i < _currentIndexList.length; i++) {
      _set(_currentIndexList[i], _current.array[i]);
    }
  }

  void _unsetCurrent() {
    for (int i = 0; i < _currentIndexList.length; i++) {
      _unset(_currentIndexList[i]);
    }
  }

  int _newPosRight(int index) {
    return index + _current.displayWidth - 1 - _current.topCenter;
  }

  int _newPosLeft(int index) {
    return index - _current.displayWidth + 1 + _current.topCenter;
  }

  int _newPosDown(int index) {
    return index + width * (_current.displayHeight - 1);
  }

  bool _checkCollide(int index) {
    var newIndexList = _createNewIndexList(index);
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

  bool _checkBeforeRightBoundary(int index) {
    return index ~/ width == _newPosRight(index) ~/ width &&
        _newPosRight(index) < array.length;
  }

  bool _checkBeforeLeftBoundary(int index) {
    return index ~/ width == _newPosLeft(index) ~/ width &&
        _newPosLeft(index) >= 0;
  }

  bool _checkBeforeBottom(int index) {
    return _newPosDown(index) < array.length;
  }

  bool moveRight() {
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

  bool moveLeft() {
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

  void _set(int index, int bit) {
    array[index] += bit;
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
