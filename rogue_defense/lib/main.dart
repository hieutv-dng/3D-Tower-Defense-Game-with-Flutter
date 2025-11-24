import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/rogue_defense_game.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Rogue Defense',
      theme: ThemeData.dark(),
      home: const GameWidget<RogueDefenseGame>.controlled(
        gameFactory: RogueDefenseGame.new,
      ),
    ),
  );
}
