import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'package:cupertino_base/configuracion/assets.dart';
import 'package:cupertino_base/pantallas/game.dart';

class Sky extends SpriteComponent with HasGameRef<GamePage> {
  Sky();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.background);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
