import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';
import 'package:flypee/components/card/rank.dart';
import 'package:flypee/components/card/suit.dart';
import 'package:flypee/components/tableau_pile.dart';
import 'package:flypee/flyepee_game.dart';
import 'package:flypee/utils/helper.dart';

import '../pile.dart';

class Card extends PositionComponent with DragCallbacks {
  final Suit suit;
  final Rank rank;
  bool _faceUp = false;
  bool _isFaceUpView = false;
  bool _isAnimatedFlip = false;
  Pile? pile;

  bool _isDragging = false;
  Vector2 _whereCardStarted = Vector2.zero();

  final List<Card> attachedCards = [];

  Card(int intRank, int intSuit)
      : suit = Suit.fromInt(intSuit),
        rank = Rank.fromInt(intRank),
        _faceUp = false,
        super(size: FlypeeGame.cardSize);

  bool get isFaceUp => _faceUp;

  bool get isFaceDown => !_faceUp;

  void flip() {
    if (_isAnimatedFlip) {
      _faceUp = _isFaceUpView;
    } else {
      _faceUp = !_faceUp;
      _isFaceUpView = _faceUp;
    }
  }

  @override
  String toString() => '${rank.label} of ${suit.label}';

  @override
  void render(Canvas canvas) {
    // if (_faceUp) {
    //   _renderFront(canvas);
    // } else {
    //   _renderBack(canvas);
    // }
    if (_isFaceUpView) {
      _renderFront(canvas);
    } else {
      _renderBack(canvas);
    }

    super.render(canvas);
  }

  static final RRect cardRRect = RRect.fromRectAndRadius(
    FlypeeGame.cardSize.toRect(),
    const Radius.circular(FlypeeGame.cardRadius),
  );

  static final Paint frontBackgroundPaint = Paint()..color = const Color(0xFF000000);
  static final Paint redBorderPaint = Paint()
    ..color = const Color(0xffece8a3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint blackBorderPaint = Paint()
    ..color = const Color(0xff7ab2e8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  static final Sprite redJack = flypeeSprite(81, 565, 562, 488);
  static final Sprite redQueen = flypeeSprite(717, 541, 486, 515);
  static final Sprite redKing = flypeeSprite(1305, 532, 407, 549);

  static final Paint blueFilter = Paint()..colorFilter = const ColorFilter.mode(Color(0x880d8bff), BlendMode.srcATop);

  static final Sprite blackJack = flypeeSprite(81, 565, 562, 488)..paint = blueFilter;
  static final Sprite blackQueen = flypeeSprite(717, 541, 486, 515)..paint = blueFilter;
  static final Sprite blackKing = flypeeSprite(1305, 532, 407, 549)..paint = blueFilter;

  void _renderFront(Canvas canvas) {
    canvas.drawRRect(cardRRect, frontBackgroundPaint);
    canvas.drawRRect(cardRRect, suit.isRed ? redBorderPaint : blackBorderPaint);

    final rankSprite = suit.isBlack ? rank.blackSprite : rank.redSprite;
    final suitSprite = suit.sprite;

    _drawSprite(canvas, rankSprite, 0.1, 0.08);
    _drawSprite(canvas, rankSprite, 0.1, 0.08, rotate: true);
    _drawSprite(canvas, suitSprite, 0.1, 0.18, scale: 0.5);
    _drawSprite(canvas, suitSprite, 0.1, 0.18, scale: 0.5, rotate: true);

    switch (rank.value) {
      case 1:
        _drawSprite(canvas, suitSprite, 0.5, 0.5, scale: 2.5);
        break;
      case 2:
        _drawSprite(canvas, suitSprite, 0.5, 0.25);
        _drawSprite(canvas, suitSprite, 0.5, 0.25, rotate: true);
        break;
      case 3:
        _drawSprite(canvas, suitSprite, 0.5, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.5);
        _drawSprite(canvas, suitSprite, 0.5, 0.2, rotate: true);
        break;
      case 4:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
      case 5:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.5);
        break;
      case 6:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        break;
      case 7:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.35);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        break;
      case 8:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.35);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.35, rotate: true);
        break;
      case 9:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.3);
        _drawSprite(canvas, suitSprite, 0.3, 0.4);
        _drawSprite(canvas, suitSprite, 0.7, 0.4);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.3, 0.4, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.4, rotate: true);
        break;
      case 10:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.3);
        _drawSprite(canvas, suitSprite, 0.3, 0.4);
        _drawSprite(canvas, suitSprite, 0.7, 0.4);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.3, rotate: true);
        _drawSprite(canvas, suitSprite, 0.3, 0.4, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.4, rotate: true);
        break;
      case 11:
        _drawSprite(canvas, suit.isRed ? redJack : blackJack, 0.5, 0.5);
        break;
      case 12:
        _drawSprite(canvas, suit.isRed ? redQueen : blackQueen, 0.5, 0.5);
        break;
      case 13:
        _drawSprite(canvas, suit.isRed ? redKing : blackKing, 0.5, 0.5);
        break;
    }
  }

  void _drawSprite(
    Canvas canvas,
    Sprite sprite,
    double relativeX,
    double relativeY, {
    double scale = 1,
    bool rotate = false,
  }) {
    if (rotate) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }

    sprite.render(
      canvas,
      position: Vector2(relativeX * size.x, relativeY * size.y),
      anchor: Anchor.center,
      size: sprite.srcSize.scaled(scale),
    );

    if (rotate) {
      canvas.restore();
    }
  }

  static final Paint backBackgroundPaint = Paint()..color = const Color(0xff380c02);
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  static final Paint backBorderPaint2 = Paint()
    ..color = const Color(0x5CEF971B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 35;

  static final RRect backRRectInner = cardRRect.deflate(40);
  static final Sprite flameSprite = flypeeSprite(1370, 6, 356, 501);

  void _renderBack(Canvas canvas) {
    canvas.drawRRect(cardRRect, backBackgroundPaint);
    canvas.drawRRect(cardRRect, backBorderPaint1);
    canvas.drawRRect(backRRectInner, backBorderPaint2);
    flameSprite.render(canvas, position: size / 2, anchor: Anchor.center);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (pile?.canMoveCard(this) ?? false) {
      super.onDragStart(event);
      _isDragging = true;
      priority = 100;
      _whereCardStarted = Vector2(position.x, position.y);

      if (pile is TableauPile) {
        attachedCards.clear();
        final extraCards = (pile! as TableauPile).cardsOnTop(this);
        for (final card in extraCards) {
          card.priority = attachedCards.length + 101;
          attachedCards.add(card);
        }
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDragged) return;
    final delta = event.localDelta;
    position.add(delta);
    for (var card in attachedCards) {
      card.position.add(delta);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDragged) return;
    super.onDragEnd(event);

    final dropPiles = parent!.componentsAtPoint(position + size / 2).whereType<Pile>().toList();
    if (dropPiles.isNotEmpty && dropPiles.first.canAcceptCard(this)) {
      pile?.removeCard(this);
      dropPiles.first.acquireCard(this);

      if (attachedCards.isNotEmpty) {
        for (var card in attachedCards) {
          dropPiles.first.acquireCard(card);
        }
        attachedCards.clear();
      }
      return;
    }
    doMove(
      _whereCardStarted,
      onComplete: () {
        pile?.returnCard(this);
      },
    );
    if (attachedCards.isNotEmpty) {
      for (var card in attachedCards) {
        final offset = card.position - position;
        card.doMove(
          _whereCardStarted + offset,
          onComplete: () {
            pile?.returnCard(card);
          },
        );
      }
      attachedCards.clear();
    }
  }

  void doMove(
    Vector2 to, {
    double speed = 10.0,
    double start = 0.0,
    Curve curve = Curves.easeOutQuad,
    VoidCallback? onComplete,
  }) {
    assert(speed > 0.0, "Speed must be > 0 widths per second");
    final dt = (to - position).length / (speed * size.x);
    assert(dt > 0.0, "Duration must be > 0.0");
    priority = 100;
    add(
      MoveToEffect(
        to,
        EffectController(duration: dt, startDelay: start, curve: curve),
        onComplete: () {
          onComplete?.call();
        },
      ),
    );
  }

  turnFaceUp({
    double time = 0.3,
    double start = 0.0,
    VoidCallback? onComplete,
  }) {
    assert(!_isFaceUpView, 'Card must be face-down before turning face-up.');
    assert(time > 0, 'Time to turn card over must be > 0');

    _isAnimatedFlip = true;
    anchor = Anchor.topCenter;
    position += Vector2(width / 2, 0);
    priority = 100;

    add(ScaleEffect.to(
        Vector2(scale.x / 100, scale.y),
        EffectController(
            startDelay: start,
            curve: Curves.easeOutSine,
            duration: time / 2,
            onMax: () => _isFaceUpView = true,
            reverseDuration: time / 2,
            onMin: () {
              _isAnimatedFlip = false;
              _faceUp = true;
              anchor = Anchor.topLeft;
              position -= Vector2(width / 2, 0);
            }), onComplete: () {
      onComplete?.call();
    }));
  }
}
