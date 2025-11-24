import 'dart:ui';
import 'package:flame_3d/game.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/resources.dart';
import 'package:flutter/services.dart';

class Defender extends Component3D {
  Defender({
    required Vector3 position,
  }) : super(position: position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Base of the defender
    add(
      MeshComponent(
        mesh: CuboidMesh(
          size: Vector3(1.2, 0.4, 1.2),
          material: SpatialMaterial(
            albedoColor: const Color(0xFF555555), // Dark Grey
            metallic: 0.8,
            roughness: 0.2,
          ),
        ),
      ),
    );

    // Turret Body
    add(
      MeshComponent(
        mesh: CuboidMesh(
          size: Vector3(0.8, 0.6, 0.8),
          material: SpatialMaterial(
            albedoColor: const Color(0xFF00FF00), // Neon Green
            metallic: 0.8,
            roughness: 0.2,
          ),
        ),
        position: Vector3(0, 0.5, 0),
      ),
    );

    // Barrel (Indicating direction)
    // Assuming -Z is forward for the defender's local space based on the lookAt logic
    add(
      MeshComponent(
        mesh: CuboidMesh(
          size: Vector3(0.2, 0.2, 1.0),
          material: SpatialMaterial(
            albedoColor: const Color(0xFF88FF88),
            metallic: 0.9,
          ),
        ),
        position: Vector3(0, 0.5, -0.8), 
      ),
    );
  }

  void lookAt(Vector3 target) {
    // We want the -Z axis of the defender to point towards the target
    // The 'forward' vector in lookAt usually corresponds to the +Z axis in the rotation matrix construction if we put it in the 3rd column.
    // If 'forward' is (position - target), it points TOWARDS the camera/viewer (if target is in front).
    // So +Z points backwards. -Z points forward (to target).
    
    final forward = (position - target)..normalize();
    
    // Avoid singularity
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
