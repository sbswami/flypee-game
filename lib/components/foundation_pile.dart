import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flypee/components/pile.dart';
import 'package:flypee/flyepee_game.dart';

import 'card/card.dart';
import 'card/suit.dart';

class FoundationPile extends PositionComponent implements Pile {
  final List<Card> _cards = [];
  final Suit suit;

  FoundationPile(int intSuit, {super.position})
      : suit = Suit.fromInt(intSuit),
        super(size: FlypeeGame.cardSize);

  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }

  final Paint _borderPaint = Paint()
    ..color = const Color(0x50ffffff)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  @override
  void render(Canvas canvas) {

    final Paint suitPaint = Paint()
      ..color = suit.isRed ? const Color(0x3a000000) : const Color(0x64000000)
      ..blendMode = BlendMode.luminosity;


    canvas.drawRRect(FlypeeGame.cardRRect, _borderPaint);
    suit.sprite.render(canvas,
        position: size / 2,
        anchor: Anchor.center,
        size: Vector2.all(FlypeeGame.cardWidth * 0.6),
        overridePaint: suitPaint);
    super.render(canvas);
  }

  @override
  bool canMoveCard(Card card) => _cards.isNotEmpty && _cards.last == card;

  @override
  bool canAcceptCard(Card card) {
    final topCardRank = _cards.isEmpty ? 0 : _cards.last.rank.value;
    return card.suit == suit && topCardRank + 1 == card.rank.value && card.attachedCards.isEmpty;
  }

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
  }

  @override
  void returnCard(Card card) {
    card.position = position;
    card.priority = _cards.indexOf(card);
  }
}
