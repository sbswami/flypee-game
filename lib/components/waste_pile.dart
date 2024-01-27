import 'package:flame/components.dart';
import 'package:flypee/components/pile.dart';
import 'package:flypee/flyepee_game.dart';

import 'card/card.dart';

class WastePile extends PositionComponent with HasGameRef<FlypeeGame> implements Pile {
  WastePile({super.position}): super(size: FlypeeGame.cardSize);

  final List<Card> _cards = [];

  @override
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);

    _fanOutTopCards();
  }

  final Vector2 _fanOffset = Vector2(FlypeeGame.cardWidth * 0.2, 0);

  void _fanOutTopCards() {
    final n = _cards.length;
    for(var i = 0; i < n; i++) {
      _cards[i].position = position;
    }
    // Above lines are need for both 1 and 3 draw
    if(game.flypeeDraw == 1) return;
    if(n == 2) {
      _cards[1].position.add(_fanOffset);
    } else if(n >= 3) {
      _cards[n - 2].position.add(_fanOffset);
      _cards[n - 1].position.addScaled(_fanOffset, 2);
    }
  }

  List<Card> removeAllCard() {
    final cards = _cards.toList();
    _cards.clear();
    return cards;
  }

  @override
  bool canMoveCard(Card card) => _cards.isNotEmpty && _cards.last == card;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
    _fanOutTopCards();
  }

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.priority = index;
    _fanOutTopCards();
  }
}