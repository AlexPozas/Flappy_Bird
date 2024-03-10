import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappybird_dj/configuracion/assets.dart';
import 'package:flappybird_dj/configuracion/configuration.dart';
import 'package:flappybird_dj/configuracion/pipe_position.dart';

import 'package:flappybird_dj/objetos/box.dart';
import 'package:flappybird_dj/pantallas/game.dart';

class PipeGroup extends PositionComponent with HasGameRef<GamePage> {
  PipeGroup();

  final _random = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Configuration.groundHeight;
    final spacing = 100 + _random.nextDouble() * (heightMinusGround / 4);
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);
    addAll([
      Pipe(height: centerY - spacing / 2, pipePosition: PipePosition.top),
      Pipe(
          height: heightMinusGround - (centerY + spacing / 2),
          pipePosition: PipePosition.bottom),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Configuration.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }

    if (game.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }
}