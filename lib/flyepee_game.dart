import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flypee/flypee_world.dart';

enum Action { newDeal, sameDeal, changeDraw, haveFun }

class FlypeeGame extends FlameGame<FlypeeWorld> {
  // Constants that won't change during the game
  static const double cardWidth = 1000;
  static const double cardHeight = 1400;
  static const double cardGap = 175;
  static const double topGap = 500;
  static const double cardRadius = 100;
  static const double cardSpaceWidth = cardWidth + cardGap;
  static const double cardSpaceHeight = cardHeight + cardGap;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  static final RRect cardRRect = RRect.fromRectAndRadius(
    FlypeeGame.cardSize.toRect(),
    const Radius.circular(FlypeeGame.cardRadius),
  );

  static const int maxInt = 0xFFFFFFFE;

  FlypeeGame() : super(world: FlypeeWorld());

  int flypeeDraw = 1;
  int seed = 1;
  Action action = Action.newDeal;
}
