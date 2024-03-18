import 'dart:math';

import 'package:cupertino_base/configuracion/appdata.dart';
import 'package:cupertino_base/configuracion/pipe_position.dart';
import 'package:cupertino_base/objetos/box.dart';
import 'package:flame/components.dart';
import 'package:cupertino_base/configuracion/configuration.dart';

import 'package:cupertino_base/configuracion/assets.dart';
import 'package:cupertino_base/pantallas/game.dart';
import 'package:flame_audio/flame_audio.dart';

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

    if (AppData.instance.gameover) {
      removeFromParent();
      //gameRef.isHit = false;
    }
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }
}
