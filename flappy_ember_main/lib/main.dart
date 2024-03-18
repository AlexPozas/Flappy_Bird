import 'package:cupertino_base/pantallas/countdown_screen.dart';
import 'package:cupertino_base/pantallas/game.dart';
import 'package:cupertino_base/pantallas/game_over_screen.dart';
import 'package:cupertino_base/pantallas/main_menu_screen.dart';
import 'package:cupertino_base/pantallas/waiting_screen.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';

void main() {
  final gamePage = GamePage();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget(
        game: gamePage,
        initialActiveOverlays: const [MainMenu.id],
        overlayBuilderMap: {
          'mainMenu': (context, _) => MainMenu(game: gamePage),
          'gameOver': (context, _) => GameOverScreen(game: gamePage),
          'countdown': (context, _) => CountDown(game: gamePage),
          'waiting': (context, _) => WaitingRoom(
                game: gamePage,
              )
        },
      ),
    ),
  );
}
