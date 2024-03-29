import 'package:cupertino_base/configuracion/appdata.dart';
import 'package:cupertino_base/configuracion/birdmovement.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:cupertino_base/configuracion/configuration.dart';

import 'package:cupertino_base/configuracion/assets.dart';
import 'package:cupertino_base/pantallas/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

class Player extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<GamePage>, CollisionCallbacks {
  Player(bool p, int i, bool f) : super() {
    this.p1 = p;
    this.id = i;
    this.fainted = f; //Temporal
  }

  String name = "P1";
  bool p1 = false;
  bool fainted = false;
  int score = 0;
  int id = 0;

  @override
  Future<void> onLoad() async {
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap
    };

    if (p1) {
      add(CircleHitbox());
      add(TextBoxComponent(
          text: name,
          position: Vector2(position.x, -20),
          anchor: Anchor.center,
          textRenderer: TextPaint(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))));
    }
  }

  void fly() {
    add(MoveByEffect(
      Vector2(0, Configuration.gravity),
      EffectController(duration: 0.2, curve: Curves.decelerate),
      onComplete: () => current = BirdMovement.down,
    ));
    current = BirdMovement.up;
    FlameAudio.play(Assets.flying);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    AppData.instance.setFainted(id);
    //gameOver();
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
    game.isHit = true;
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
    fainted = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (p1 && !fainted) position.y += Configuration.birdVelocity * dt;
    if (position.y <= 0) {
      //gameOver();
      AppData.instance.setFainted(id);
    }
    if (AppData.instance.gameover) gameOver();
  }

  void setName(String name) {
    this.name = name;
  }

  int getScore() {
    return score;
  }
}
