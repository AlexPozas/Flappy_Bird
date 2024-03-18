import 'dart:convert';

import 'package:cupertino_base/objetos/player.dart';
import 'package:cupertino_base/pantallas/game.dart';
import 'package:cupertino_base/pantallas/websockets_manager.dart';

import 'package:flutter/material.dart';

class AppData {
  static AppData instance = AppData();

  AppData();

  //Variables
  List<String> playersName = ['Pepe', 'Jose Roberto', 'Joel', 'Dani'];
  List<int> playerScore = [0, 0, 0, 0];
  List<Player> playersList = [
    Player(true, 0, false),
    Player(false, 1, true),
    Player(false, 2, true),
    Player(false, 3, true)
  ];

  String name = "";
  bool gameover = false;
  late GamePage game;

  late WebSocketsHandler websocket;

  //Functions
  static AppData getInstance() {
    return instance;
  }

  void resetGame() {
    for (int i = 0; i < playersList.length; i++) {
      playersList[i].reset();
    }
  }

  void getScore() {
    //Get each players score
    for (int i = 0; i < playersList.length; i++) {
      playerScore[i] = playersList[i].score + 0;
    }
  }

  void setFainted(int id) {
    playersList[id].fainted = true;
    checkGameOver();
  }

  void checkGameOver() {
    int num = 0; //Num of players fainted
    for (Player b in playersList) {
      if (b.fainted) num += 1;
    }
    if (num >= 4) {
      //If all are fainted
      getScore();
      gameover = true;
    }
  }

  void initializeWebsocket(String serverIp) {
    websocket = WebSocketsHandler();
    websocket.connectToServer(serverIp, serverMessageHandler);
  }

  void serverMessageHandler(String message) {
    print("Message recived: $message");

    final data = json.decode(message);

    if (data is Map<String, dynamic>) {
      if (data['type'] == 'loquesea') {
        // lo que hay que hacer
      }
    }
  }
}
