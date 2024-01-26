import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flypee/components/foundation_pile.dart';
import 'package:flypee/components/tableau_pile.dart';
import 'package:flypee/components/stock_pile.dart';
import 'package:flypee/components/waste_pile.dart';

import 'components/card/card.dart';

class FlypeeGame extends FlameGame {
  // Constants that won't change during the game
  static const double cardWidth = 1000;
  static const double cardHeight = 1400;
  static const double cardGap = 175;
  static const double cardRadius = 100;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);

  static final RRect cardRRect = RRect.fromRectAndRadius(
    FlypeeGame.cardSize.toRect(),
    const Radius.circular(FlypeeGame.cardRadius),
  );

  @override
  Future<void> onLoad() async {
    await Flame.images.load("sprites.png");

    // Create the stock
    final stock = StockPile()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);

    // Create the waste
    final waste = WastePile()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);

    // Create the foundations x4
    final foundations = List.generate(
      4,
      (index) => FoundationPile(index)
        ..size = cardSize
        ..position = Vector2((index + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );

    // Create the Pile x7
    final piles = List.generate(
      7,
      (index) => TableauPile()
        ..size = cardSize
        ..position = Vector2(cardGap + index * (cardGap + cardWidth), cardHeight + 2 * cardGap),
    );

    // Add all the components to the game
    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(piles);

    // Set Camera view finder
    camera.viewfinder.visibleGameSize = Vector2(7 * cardWidth + 8 * cardGap, 4 * cardHeight + 3 * cardGap);
    camera.viewfinder.position = Vector2(3.5 * cardWidth + 4 * cardGap, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit < 4; suit++) Card(rank, suit)
    ];

    cards.shuffle();
    world.addAll(cards);

    int cardToDeal = cards.length - 1;
    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        piles[j].acquireCard(cards[cardToDeal--]);
      }
      piles[i].flipTopCard();
    }

    for (var n = 0; n <= cardToDeal; n++) {
      stock.acquireCard(cards[n]);
    }

    return super.onLoad();
  }
}
