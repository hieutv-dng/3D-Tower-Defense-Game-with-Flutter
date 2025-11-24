import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_3d/game.dart'; // For Vector3 if needed
import 'enemy.dart';

class EnemySpawner extends Component {
  final Vector3 targetPosition;
  final Random _rng = Random();
  late Timer _timer;

  EnemySpawner({required this.targetPosition}) {
    _timer = Timer(2.0, repeat: true, onTick: _spawnEnemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
  }

  void _spawnEnemy() {
    // Spawn at random X at fixed Z (top of screen relative to defender)
    // Defender is at Z=8. Camera at Z=20 looking at 0.
    // Let's spawn at Z = -15 (further back).
    
    final x = (_rng.nextDouble() * 16) - 8;
    final z = -15.0;
    
    final typeRoll = _rng.nextDouble();
    EnemyType type;
    if (typeRoll < 0.6) {
      type = EnemyType.standard;
    } else if (typeRoll < 0.85) {
      type = EnemyType.fast;
    } else {
      type = EnemyType.heavy;
    }
    
    parent?.add(
      Enemy(
        position: Vector3(x, 0, z),
        targetPosition: targetPosition,
        type: type,
      ),
    );
  }
}
