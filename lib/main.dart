import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  late SpriteAnimationComponent animationComponent;
  late JoystickComponent joystick;
  late SpriteAnimation leftAnimation,
      rightAnimation,
      upAnimation,
      downAnimation;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    animationComponent = SpriteAnimationComponent(
      size: Vector2(112 * 2, 133 * 2),
      position: Vector2(size.x / 2, size.y / 2),
    )..anchor = Anchor.center;

    await loadAnimations();
    animationComponent.animation = downAnimation;

    add(animationComponent);

    // Create the joystick
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: Paint()..color = Colors.red),
      background: CircleComponent(
          radius: 100, paint: Paint()..color = Colors.white.withOpacity(0.5)),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    add(joystick);
  }

  Future<void> loadAnimations() async {
    SpriteSheet spriteSheet = SpriteSheet(
      image: await images.load('red hood itch free Copy-Sheet.png'),
      srcSize: Vector2(112, 133),
    );

    leftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: 0.05, from: 0, to: 23);
    rightAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: 0.05, from: 0, to: 23);
    upAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: 0.05, from: 0, to: 23);
    downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.05, from: 0, to: 23);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (joystick.direction != JoystickDirection.idle) {
      animationComponent.position.add(joystick.relativeDelta * 200 * dt);

      // Change the animation based on the direction of movement
      if (joystick.relativeDelta.x > 0) {
        animationComponent.animation = rightAnimation;
      } else if (joystick.relativeDelta.x < 0) {
        animationComponent.animation = leftAnimation;
      } else if (joystick.relativeDelta.y > 0) {
        animationComponent.animation = downAnimation;
      } else if (joystick.relativeDelta.y < 0) {
        animationComponent.animation = upAnimation;
      }
    }
  }
}
