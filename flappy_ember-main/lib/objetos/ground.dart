import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flappybird_dj/configuracion/assets.dart';
import 'package:flappybird_dj/configuracion/configuration.dart';
import 'package:flappybird_dj/pantallas/game.dart';

class Ground extends ParallaxComponent<GamePage> with HasGameRef<GamePage> {
  Ground();

  @override
  Future<void> onLoad() async {
    final ground = await Flame.images.load(Assets.ground);
    parallax =
        Parallax([ParallaxLayer(ParallaxImage(ground, fill: LayerFill.none))]);

    add(RectangleHitbox(
        position: Vector2(0, gameRef.size.y - Configuration.groundHeight),
        size: Vector2(gameRef.size.x, Configuration.groundHeight)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = Configuration.gameSpeed;
  }
}
