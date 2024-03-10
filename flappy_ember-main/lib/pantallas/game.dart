import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flappybird_dj/configuracion/configuration.dart';
import 'package:flappybird_dj/objetos/box_stack.dart';
import 'package:flappybird_dj/objetos/ground.dart';
import 'package:flappybird_dj/objetos/player.dart';
import 'package:flappybird_dj/objetos/sky.dart';

import 'package:flutter/material.dart';

class GamePage extends FlameGame with TapDetector, HasCollisionDetection {
  GamePage();

  late Player bird;
  late TextBoxComponent score;
  Timer interval = Timer(Configuration.pipeInterval, repeat: true);
  bool isHit = false;

  @override
  Future<void> onLoad() async {
    addAll([
      Sky(),
      Ground(),
      bird = Player(),
      score = buildScore(),
    ]);

    interval.onTick = () => add(PipeGroup());
  }

  TextBoxComponent buildScore() {
    return TextBoxComponent(
        text: 'Score: 0',
        position: Vector2(size.x / 2, size.y / 2 * 0.2),
        anchor: Anchor.center,
        textRenderer: TextPaint(
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Game')));
  }

  @override
  void onTap() {
    super.onTap();
    bird.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    score.text = "Score: ${bird.score}";
  }
}
