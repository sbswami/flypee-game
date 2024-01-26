import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flypee/flyepee_game.dart';

void main() {
  final game = FlypeeGame();
  runApp(GameWidget(game: game));
}