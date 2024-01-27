import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flypee/flyepee_game.dart';
import 'components/card/card.dart';
import 'components/foundation_pile.dart';
import 'components/stock_pile.dart';
import 'components/tableau_pile.dart';
import 'components/waste_pile.dart';

class FlypeeWorld extends World with HasGameRef<FlypeeGame> {
  @override
  Future<void> onLoad() async {
    await Flame.images.load("sprites.png");

    // Create the stock
    final stock = StockPile()
      ..size = FlypeeGame.cardSize
      ..position = Vector2(FlypeeGame.cardGap, FlypeeGame.cardGap);

    // Create the waste
    final waste = WastePile()
      ..size = FlypeeGame.cardSize
      ..position = Vector2(FlypeeGame.cardWidth + 2 * FlypeeGame.cardGap, FlypeeGame.cardGap);

    // Create the foundations x4
    final foundations = List.generate(
      4,
      (index) => FoundationPile(index)
        ..size = FlypeeGame.cardSize
        ..position =
            Vector2((index + 3) * (FlypeeGame.cardWidth + FlypeeGame.cardGap) + FlypeeGame.cardGap, FlypeeGame.cardGap),
    );

    // Create the Pile x7
    final piles = List.generate(
      7,
      (index) => TableauPile()
        ..size = FlypeeGame.cardSize
        ..position = Vector2(FlypeeGame.cardGap + index * (FlypeeGame.cardGap + FlypeeGame.cardWidth),
            FlypeeGame.cardHeight + 2 * FlypeeGame.cardGap),
    );

    // Add all the components to the game
    add(stock);
    add(waste);
    addAll(foundations);
    addAll(piles);

    final camera = game.camera;
    // Set Camera view finder
    camera.viewfinder.visibleGameSize =
        Vector2(7 * FlypeeGame.cardWidth + 8 * FlypeeGame.cardGap, 4 * FlypeeGame.cardHeight + 3 * FlypeeGame.cardGap);
    camera.viewfinder.position = Vector2(3.5 * FlypeeGame.cardWidth + 4 * FlypeeGame.cardGap, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit < 4; suit++) Card(rank, suit)
    ];

    cards.shuffle();
    addAll(cards);

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
