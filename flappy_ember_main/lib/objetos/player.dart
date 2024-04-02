import 'dart:io';

import 'package:cupertino_base/configuracion/appdata.dart';
import 'package:cupertino_base/configuracion/birdmovement.dart';
import 'package:cupertino_base/objetos/box_stack.dart';
import 'package:cupertino_base/objetos/ground.dart';
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
  Player({bool p = false, String name = "YOU", id = 0, f = false}) : super() {
    this.p1 = p;
    this.name = name;
    this.id = id;
    this.fainted = f;
  }

  String name = "YOU";
  bool p1 = false;
  bool fainted = false;
  int score = 0;
  int id = 0;

  @override
  Future<void> onLoad() async {
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);
    final birdDeath = await _loadImage(Assets.birdMidFlap);

    size = Vector2(35, 35);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
      BirdMovement.death: birdDeath
    };

    if (p1) {
      add(CircleHitbox());
      add(TextBoxComponent(
          text: name,
          position: Vector2(position.x + (size.x * 2) * 0.75, -20),
          anchor: Anchor.center,
          textRenderer: TextPaint(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
    }
  }

  void fly() {
    if (!fainted) {
      add(MoveByEffect(
        Vector2(0, Configuration.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      ));
      current = BirdMovement.up;
      FlameAudio.play(Assets.flying);
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if ((other is PipeGroup || other is Pipe || other is Ground) && p1) {
      fainted = true;
      current = BirdMovement.death;
      AppData.instance.setFainted(id);
      AppData.instance.sendFainted();
    }
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    name = "Waiting...";
    score = 0;
    //fainted = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (p1 && !fainted) position.y += Configuration.birdVelocity * dt;
    if (position.y <= 0 && p1) {
      //gameOver();
      AppData.instance.setFainted(id);
      AppData.instance.sendFainted();
    }
    if (AppData.instance.gameover) gameOver();
  }

  void setName(String name) {
    this.name = name;
  }

  int getScore() {
    return score;
  }

  Future<Sprite> _loadImage(String imgPath) async {
    final image = await gameRef.loadSprite(imgPath);

    if (!p1) {
      image.paint.color = image.paint.color.withOpacity(0.5);
      print(image);
    }

    return image;
  }
}
