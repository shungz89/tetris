import 'package:tetris/model/playfield.dart';
import 'package:tetris/model/tetromino.dart';

void main() {
  var I = Tetromino([1, 1, 1, 1], width: 4);
  var O = Tetromino([1, 1, 1, 1], width: 2);
  var T = Tetromino([0, 1, 0, 1, 1, 1], width: 3);
  var S = Tetromino([0, 1, 1, 1, 1, 0], width: 3);
  var Z = Tetromino([1, 1, 0, 0, 1, 1], width: 3);
  var J = Tetromino([1, 0, 0, 1, 1, 1], width: 3);
  var L = Tetromino([0, 0, 1, 1, 1, 1], width: 3);
  List<Tetromino> tetrominos = [I, O, T, S, Z, J, L];
  var playField = PlayField(10, 24, tetrominos: [T]);

  playField.proceed();
  playField.moveDown();
  playField.moveLeft();
  print(playField);
  playField.rotateRight();
  print(playField);
  playField.moveLeft();
  print(playField);
  playField.moveLeft();
  print(playField);
  playField.moveLeft();
  print(playField);
  playField.moveLeft();
  print(playField);
  playField.moveLeft();
  print(playField);
  playField.moveLeft();
  print(playField);

}
