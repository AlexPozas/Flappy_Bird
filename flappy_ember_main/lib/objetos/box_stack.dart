import 'dart:math';

import 'package:cupertino_base/configuracion/appdata.dart';
import 'package:cupertino_base/configuracion/assets.dart';
import 'package:cupertino_base/configuracion/configuration.dart';
import 'package:cupertino_base/configuracion/pipe_position.dart';
import 'package:cupertino_base/objetos/box.dart';
import 'package:cupertino_base/pantallas/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class PipeGroup extends PositionComponent with HasGameRef<GamePage> {
  final double spacing;
  final double centerY;

  PipeGroup(this.spacing, this.centerY);
  final _random = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Configuration.groundHeight;

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
    }
  }

  void updateScore() {
    if (AppData.instance.playersList[AppData.instance.myIdNum].fainted ==
        false) {
      AppData.instance.playersList[AppData.instance.myIdNum].score += 1;
      FlameAudio.play(Assets.point);
    }
  }
}
