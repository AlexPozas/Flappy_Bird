import 'dart:convert';
import 'dart:io';

import 'package:cupertino_base/configuracion/birdmovement.dart';
import 'package:cupertino_base/objetos/box_stack.dart';
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
    Player(id: 0),
    Player(id: 1),
    Player(id: 2),
    Player(id: 3)
  ];

  String myName = "";
  bool gameover = false;
  late GamePage game;
  String myId = "";
  int myIdNum = 0;
  bool charging = false;

  late WebSocketsHandler websocket;
  bool wsIsOn = false;

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
    playersList.clear();
    for (int i = 0; i < 4; i++) {
      playersList.add(Player());
    }
    websocket.closeConnection();
  }

  void setPlayers() {
    gameover = false;
    List<Player> tempList = [];
    for (Player b in playersList) {
      if (b.p1) {
        tempList.add(Player(p: true, name: b.name, id: b.id));
      } else {
        tempList.add(Player(name: b.name, id: b.id));
      }
    }
    playersList.clear();
    playersList = tempList;
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
    wsIsOn = true;
  }

  void serverMessageHandler(String message) {
    print("Message recived: $message");

    final data = json.decode(message);

    if (data is Map<String, dynamic>) {
      if (data['type'] == 'welcome') {
        websocket.sendMessage('{ "type": "init", "name": "$myName"}');
        sleep(Duration(seconds: 1));
        myId = data['id'];
        gameover = false;
      } else if (data['type'] == 'waitingList') {
        List<dynamic> list = data['data'];
        for (int i = 0; i < list.length; i++) {
          playersList[i].name = list[i]['name'];
          if (list[i]['id'] == myId) {
            myIdNum = i;
            playersList[i].p1 = true;
            game.resetGame();
          }
        }
        notifyListeners();
        if (game.overlays.isActive('mainMenu')) {
          game.overlays.add('waiting');
          game.overlays.remove('mainMenu');
        } else {
          game.overlays.remove('waiting');
          game.overlays.add('waiting');
        }
      } else if (data['type'] == 'start') {
        setPlayers();
        game.resetGame();
        game.overlays.add('countdown');
        game.overlays.remove('waiting');
      } else if (data['type'] == 'data') {
        List<dynamic> list = data['data'];
        for (int i = 0; i < list.length; i++) {
          if (list[i]['id'] != myId) {
            playersList[i].position.x = double.parse(list[i]['x']);
            playersList[i].position.y = double.parse(list[i]['y']);
            playersList[i].score = int.parse(list[i]["puntuation"]);
          }
        }
      } else if (data["type"] == "pipe") {
        game.add(PipeGroup(data["spacing"], data["centerY"]));
      } else if (data['type'] == 'lost') {
        int posList = int.parse(data['positionList']);
        playersList[posList].fainted = true;
        playersList[posList].current = BirdMovement.death;
      } else if (data['type'] == 'finnish') {
        gameover = true;
        List<dynamic> list = data['data'];
        for (int i = 0; i < list.length; i++) {
          playersList[i].score = int.parse(list[i]['puntuation']);
        }
        game.overlays.add("gameover");
      }
    }
  }

  void sendMyPosition() {
    if (wsIsOn) {
      double myX = playersList[myIdNum].position.x;
      double myY = playersList[myIdNum].position.y;

      websocket.sendMessage('{ "type": "move", "x": "$myX", "y": "$myY" }');
    }
  }

  void sendFainted() {
    int myScore = playersList[myIdNum].score;
    websocket.sendMessage(
        '{  "type": "loose", "puntuation": "$myScore" , "positionList": "$myIdNum"}');
  }
}
