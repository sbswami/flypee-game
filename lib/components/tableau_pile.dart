import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flypee/components/pile.dart';
import 'package:flypee/flyepee_game.dart';

import 'card/card.dart';

class TableauPile extends PositionComponent  implements Pile{
  TableauPile({super.position}) : super(size: FlypeeGame.cardSize);

  final Paint _borderPaint = Paint()
    ..color = const Color(0x50ffffff)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  final List<Card> _cards = [];
  final Vector2 _fanOffset1 = Vector2(0, FlypeeGame.cardHeight * 0.1);
  final Vector2 _fanOffset2 = Vector2(0, FlypeeGame.cardHeight * 0.2);

  @override
  void acquireCard(Card card) {

    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);

    layOutCards();
  }

  void flipTopCard() {
    assert(_cards.last.isFaceDown);
    _cards.last.flip();
  }

  List<Card> cardsOnTop(Card card){
    assert(card.isFaceUp && _cards.contains(card));
    final index = _cards.indexOf(card);
    return _cards.getRange(index + 1, _cards.length).toList();
  }

  void layOutCards() {
    if(_cards.isEmpty) return;
    _cards[0].position = position;
    for(var i = 1; i < _cards.length; i++) {
      _cards[i].position
          ..setFrom(_cards[i - 1].position)
          ..add(_cards[i - 1].isFaceDown ? _fanOffset1 : _fanOffset2);
    }

    // Increased height of tableau pile
    height = FlypeeGame.cardHeight * 1.5 + _cards.last.y - _cards.first.y;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(FlypeeGame.cardRRect, _borderPaint);
    super.render(canvas);
  }

  @override
  bool canMoveCard(Card card) => card.isFaceUp;

  @override
  bool canAcceptCard(Card card) {
    if(_cards.isEmpty) return card.rank.value == 13;
    return _cards.last.suit.isRed == !card.suit.isRed && _cards.last.rank.value == card.rank.value + 1;
  }

  @override
  void removeCard(Card card) {
    assert(_cards.contains(card) && card.isFaceUp);
    final index = _cards.indexOf(card);
    _cards.removeRange(index, _cards.length);
    if(_cards.isNotEmpty && _cards.last.isFaceDown) flipTopCard();
    layOutCards();
  }

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.priority = index;
    layOutCards();
  }
}
