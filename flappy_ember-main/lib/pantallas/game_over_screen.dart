import 'package:flappybird_dj/configuracion/assets.dart';
import 'package:flappybird_dj/pantallas/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameOverScreen extends StatelessWidget {
  final GamePage game;
  static const String id = 'gameOver';

  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Score: ${game.bird.score}",
              style: TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: "Game",
              ),
            ),
            Image.asset(Assets.gameOver),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: restartGame,
                child: const Text(
                  "Restart",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }

  void restartGame() {
    game.bird.reset();
    game.overlays.add('mainMenu');
    game.overlays.remove('gameOver');

    //game.resumeEngine();
  }
}
