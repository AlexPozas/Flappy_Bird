import 'dart:convert';
import 'dart:io';

import 'package:cupertino_base/objetos/player.dart';
import 'package:cupertino_base/pantallas/game.dart';
import 'package:cupertino_base/pantallas/websockets_manager.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  static AppData instance = AppData();

  AppData();

  //Variables
  List<int> playerScore = [0, 0, 0, 0];
  List<Player> playersList = [
    Player(true, 0, false),
    Player(false, 1, true),
    Player(false, 2, true),
    Player(false, 3, true)
  ];

  String myName = "";
  bool gameover = false;
  late GamePage game;
  String myId = "";
  int myIdNum = 0;

  late WebSocketsHandler websocket;

  //Functions
  static AppData getInstance() {
    return instance;
  }

  String getPlayerName(id) {
    return playersList[id].name;
  }

  int getPlayerScore(id) {
    return playersList[id].score;
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

  void initializeWebsocket(String serverIp, String name, GamePage g) {
    this.game = g;
    websocket = WebSocketsHandler();
    websocket.connectToServer(serverIp, serverMessageHandler);
    myName = name;
  }

  void serverMessageHandler(String message) {
    print("Message recived: $message");

    final data = json.decode(message);

    if (data is Map<String, dynamic>) {
      if (data['type'] == 'welcome') {
        websocket.sendMessage('{ "type": "init", "name": "$myName"}');
        sleep(Duration(seconds: 1));
        myId = data['id'];
      }
      if (data['type'] == 'waitingList') {
        List<dynamic> list = data['data'];
        print(list);
        for (int i = 0; i < list.length; i++) {
          playersList[i].name = list[i]['name'];
          notifyListeners();
          if (list[i]['id'] == myId) myIdNum = i;
          print(playersList[i].name);
        }
        game.overlays.remove('mainMenu');
        game.overlays.add('waiting');
        AppData.instance.gameover = false;
      }
    }
  }

  void resetPlayerList() {
    for (Player player in playersList) {
      player.name = "Waiting...";
      player.p1 = false;
      player.fainted = false;
      player.score = 0;
      player.id = 0;
      player.position = Vector2(50, game.size.y / 2 - player.size.y / 2);
    }
  }
}
