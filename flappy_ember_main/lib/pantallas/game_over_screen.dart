import 'package:cupertino_base/configuracion/assets.dart';

import 'package:cupertino_base/pantallas/game.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_base/configuracion/appdata.dart';

class GameOverScreen extends StatelessWidget {
  final GamePage game;
  static const String id = 'gameOver';

  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              child: ListView.builder(
                itemCount: AppData.instance.playerScore.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/' + Assets.birdMidFlap[index],
                          width: 60,
                          height: 60,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          AppData.instance.playersName[index],
                          style: TextStyle(
                            fontSize: 40,
                            color: Assets.fontColors[index],
                            fontFamily: "Game",
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${AppData.instance.playerScore[index]}p',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontFamily: "Game",
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: restartGame,
                child: const Text(
                  "END",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }

  void restartGame() {
    game.overlays.add('mainMenu');
    game.overlays.remove('gameOver');
    AppData.instance.resetGame();
    //game.resumeEngine();
  }
}
