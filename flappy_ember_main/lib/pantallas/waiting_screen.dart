import 'package:cupertino_base/pantallas/game.dart';

import 'package:flutter/material.dart';

class WaitingRoom extends StatefulWidget {
  final GamePage game;

  const WaitingRoom({Key? key, required this.game}) : super(key: key);

  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _waiting ? Text('Waiting...') : Container(),
      ),
    );
  }
}
