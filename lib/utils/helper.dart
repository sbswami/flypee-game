import 'package:flame/components.dart';
import 'package:flame/flame.dart';

Sprite flypeeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}