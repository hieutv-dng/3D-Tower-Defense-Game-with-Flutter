import 'dart:ui';
import 'package:flame_3d/game.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/resources.dart';
import 'package:flutter/services.dart';

class Defender extends MeshComponent {
  Defender({
    required Vector3 position,
  }) : super(
          mesh: CuboidMesh(
            size: Vector3(1, 1, 1),
            material: SpatialMaterial(
              albedoColor: const Color(0xFF00FF00), // Neon Green
              metallic: 0.8,
              roughness: 0.2,
            ),
          ),
          position: position,
        );

  void lookAt(Vector3 target) {
    final forward = (position - target)..normalize();
    // Ensure we don't have a zero vector or parallel to up
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
