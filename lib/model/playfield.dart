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
      var newList = List.of(array);
      var removed = 0;
      for (int i = height - 1; i >= 0; i--) {
        if (newList
            .sublist(width * i, width * i + width)
            .every((value) => value == 1)) {
          removed++;
          newList.removeRange(width * i, width * i + width);
        }
      }
      if (removed > 0) {
        newList.insertAll(0, List.filled(width * removed, 0));
        array.setAll(0, newList);
      }
      if (!_add(random.clone())) {
        print("Game Over!");
        _current = null;
        return false;
      }
    }
    print(this);
    return true;
  }

  List<int> _createNewIndexList(int index, Tetromino tetromino) {
    var newIndexList = List<int>(tetromino.display.length);
    for (int i = 0; i < newIndexList.length; i++) {
      var newIndex = index +
          (i % tetromino.displayWidth) +
          (i ~/ tetromino.displayWidth * width) -
          tetromino.topCenter;
      newIndexList[i] = newIndex;
    }
    return newIndexList;
  }

  bool _setCurrent(int index) {
    var newIndexList = _createNewIndexList(index, _current);
    _currentIndexList = newIndexList;
    for (int i = 0; i < _currentIndexList.length; i++) {
      var value = _set(_currentIndexList[i], _current.display[i]);
      if (value > 1) return false;
    }
    return true;
  }

  void _unsetCurrent() {
    for (int i = 0; i < _currentIndexList.length; i++) {
      if (_current.display[i] == 1) {
        _unset(_currentIndexList[i]);
      }
    }
  }

  int _calcPosRight(int index, Tetromino tetromino) {
    return index + tetromino.displayWidth - 1 - tetromino.topCenter;
  }

  int _calcPosLeft(int index, Tetromino tetromino) {
    return index -
        tetromino.displayWidth +
        tetromino.displayWidth -
        tetromino.topCenter;
  }

  int calcPosDown(int index, Tetromino tetromino) {
    return index + width * (tetromino.displayHeight - 1);
  }

  bool _checkCollide(int index, Tetromino tetromino) {
    var newIndexList = _createNewIndexList(index, tetromino);
    for (int i = 0; i < newIndexList.length; i++) {
      var newIndex = newIndexList[i];
      if (array[newIndex] + tetromino.display[i] > 1) {
        return true;
      }
    }
    return false;
  }

  bool _checkBeforeRight(int index, Tetromino tetromino) {
    return _calcPosRight(index, tetromino) ~/ width ==
            _calcPosRight(_currentIndex, tetromino) ~/ width &&
        _calcPosRight(index, tetromino) < array.length;
  }

  bool _checkBeforeLeft(int index, Tetromino tetromino) {
    return _calcPosLeft(index, tetromino) ~/ width ==
            _calcPosLeft(_currentIndex, tetromino) ~/ width &&
        _calcPosLeft(index, tetromino) >= 0;
  }

  bool _checkBeforeBottom(int index, Tetromino tetromino) {
    return calcPosDown(index, tetromino) < array.length;
  }

  bool rotateLeft() {
    if (_current == null) return false;
    _unsetCurrent();
    var rotate = _current.clone().rotateCounter();
    var newIndex = max(
      _currentIndex,
      _currentIndex ~/ width * width + _current.centerLeft,
    );
    if (!_checkCollide(newIndex, rotate)) {
      _current.rotateCounter();
      _currentIndex = newIndex;
      _setCurrent(_currentIndex);
      return true;
    } else {
      _setCurrent(_currentIndex);
      print("Collided!");
      return false;
    }
  }

  bool rotateRight() {
    if (_current == null) return false;
    _unsetCurrent();
    var rotate = _current.clone().rotateClockwise();
    var newIndex = min(
        _currentIndex,
        (_currentIndex ~/ width + 1) * width -
            (_current.displayHeight - _current.centerLeft));
    if (!_checkCollide(newIndex, rotate)) {
      _current.rotateClockwise();
      _currentIndex = newIndex;
      _setCurrent(_currentIndex);
      return true;
    } else {
      _setCurrent(_currentIndex);
      print("Collided!");
      return false;
    }
  }

  bool moveRight() {
    if (_current == null) return false;
    var newIndex = _currentIndex + 1;
    _unsetCurrent();
    if (_checkBeforeRight(newIndex, _current) &&
        !_checkCollide(newIndex, _current)) {
      _currentIndex = newIndex;
      _setCurrent(_currentIndex);
      return true;
    } else {
      _setCurrent(_currentIndex);
      print("Collided!");
      return false;
    }
  }

  bool moveLeft() {
    if (_current == null) return false;
    var newIndex = _currentIndex - 1;
    _unsetCurrent();
    if (_checkBeforeLeft(newIndex, _current) &&
        !_checkCollide(newIndex, _current)) {
      _currentIndex = newIndex;
      _setCurrent(_currentIndex);
      return true;
    } else {
      _setCurrent(_currentIndex);
      print("Collided!");
      return false;
    }
  }

  bool moveDown() {
    if (_current == null) return false;
    var newIndex = _currentIndex + width;
    _unsetCurrent();
    if (_checkBeforeBottom(newIndex, _current) &&
        !_checkCollide(newIndex, _current)) {
      _currentIndex = newIndex;
      _setCurrent(_currentIndex);
      return true;
    } else {
      _setCurrent(_currentIndex);
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
