import 'dart:ui';
import 'package:flame_3d/game.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/resources.dart';

class Enemy extends MeshComponent {
  final Vector3 targetPosition;
  final double speed = 2.0;

  Enemy({
    required Vector3 position,
    required this.targetPosition,
  }) : super(
          mesh: CuboidMesh(
            size: Vector3(0.8, 0.8, 0.8),
            material: SpatialMaterial(
              albedoColor: const Color(0xFFFF0000), // Neon Red
            ),
          ),
          position: position,
        );

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move towards target
    final direction = targetPosition - position;
    direction.y = 0;
    
    if (direction.length > 0.1) {
      direction.normalize();
      position.add(direction * speed * dt);
      
      // Also look at target
      _lookAt(targetPosition);
    } else {
      // Reached target (Game Over or Damage logic later)
      removeFromParent();
    }
  }

  void _lookAt(Vector3 target) {
    final forward = (position - target)..normalize();
    if (forward.length2 < 0.0001 || (forward.x == 0 && forward.z == 0)) return;

    final up = Vector3(0, 1, 0);
    final right = up.cross(forward)..normalize();
    final realUp = forward.cross(right)..normalize();
    
    final rotMat = Matrix3(
      right.x, realUp.x, forward.x,
      right.y, realUp.y, forward.y,
      right.z, realUp.z, forward.z,
    );
    
    transform.rotation = Quaternion.fromRotation(rotMat);
  }
}
