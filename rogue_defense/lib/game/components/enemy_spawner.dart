import 'dart:math';
import 'package:flame/components.dart';
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
    // Defender is at Z=4. Camera at Z=15 looking at 0.
    // Top of screen is negative Z.
    // Let's spawn at Z = -10.
    // X range: -8 to 8 (approx arena width).
    
    final x = (_rng.nextDouble() * 16) - 8;
    final z = -10.0;
    
    parent?.add(
      Enemy(
        position: Vector3(x, 0, z),
        targetPosition: targetPosition,
      ),
    );
  }
}
