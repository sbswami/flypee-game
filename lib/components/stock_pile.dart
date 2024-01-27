import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flypee/components/pile.dart';
import 'package:flypee/components/waste_pile.dart';
import 'package:flypee/flyepee_game.dart';

import 'card/card.dart';

class StockPile extends PositionComponent with TapCallbacks, HasGameRef<FlypeeGame> implements Pile {
  StockPile({super.position}) : super(size: FlypeeGame.cardSize);

  final List<Card> _cards = [];

  @override
  void acquireCard(Card card) {
    assert(card.isFaceDown);
    card.position = position;
    card.priority = _cards.length; // Last is first out
    card.pile = this;
    _cards.add(card);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final WastePile? wastePile = parent?.firstChild<WastePile>();
    if (wastePile == null) return super.onTapUp(event);
    if (_cards.isEmpty) {
      wastePile.removeAllCard().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    } else {
      for (var i = 0; i < game.flypeeDraw; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }
      }
    }
  }

  final _borderPaint = Paint()
    ..color = const Color(0xFF3F5B5D)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  final _circlePaint = Paint()
    ..color = const Color(0x883F5B5D)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(FlypeeGame.cardRRect, _borderPaint);
    canvas.drawCircle(Offset(width / 2, height / 2), FlypeeGame.cardWidth * 0.3, _circlePaint);

    super.render(canvas);
  }

  @override
  bool canMoveCard(Card card) => false;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card) => throw StateError("cannot remove card from here");

  @override
  void returnCard(Card card) => throw StateError('cannot return card here');
}
