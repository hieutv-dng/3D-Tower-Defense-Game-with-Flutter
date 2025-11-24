import 'dart:async';
import 'dart:ui' hide Image;

import 'package:flame/events.dart';
import 'package:flame_3d/game.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/resources.dart';
import 'package:flame_3d/camera.dart';
import 'package:flutter/material.dart' hide Texture, Image;
import 'components/defender.dart';
import 'components/enemy_spawner.dart';

class RogueDefenseGame extends FlameGame3D<World3D, CameraComponent3D> with PanDetector {
  RogueDefenseGame()
      : super(
          world: World3D(clearColor: const Color(0xFF111111)),
          camera: CameraComponent3D(
            position: Vector3(0, 20, 10), // Adjusted for better top-down view
            target: Vector3(0, 0, 0),
            up: Vector3(0, 1, 0),
            fovY: 60,
          ),
        );

  late Defender defender;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Lighting
    world.add(
      LightComponent.point(
        position: Vector3(0, 20, 0),
        intensity: 40.0,
      ),
    );
    world.add(
      LightComponent.ambient(
        intensity: 0.3,
      ),
    );

    // Ground
    world.add(
      MeshComponent(
        mesh: CuboidMesh(
           size: Vector3(30, 0.5, 40),
           material: SpatialMaterial(albedoColor: const Color(0xFF222222)),
        ),
        position: Vector3(0, -1, 0),
      ),
    );

    // Defender
    final defenderPos = Vector3(0, 0, 8);
    defender = Defender(position: defenderPos);
    world.add(defender);

    // Enemy Spawner
    world.add(EnemySpawner(targetPosition: defenderPos));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Raycast to find point on ground
    final groundPoint = getGroundIntersection(info.eventPosition.widget);
    
    if (groundPoint != null) {
      defender.lookAt(groundPoint);
    }
  }

  Vector3? getGroundIntersection(Vector2 screenPosition) {
    // Note: This relies on the camera's viewport size and projection matrix being up-to-date.
    final viewportSize = camera.viewport.virtualSize;
    
    // NDC: x in [-1, 1], y in [1, -1] (Standard OpenGL)
    // Screen: (0,0) top-left
    final x = (2.0 * screenPosition.x) / viewportSize.x - 1.0;
    final y = 1.0 - (2.0 * screenPosition.y) / viewportSize.y;
    
    final rayStart = Vector4(x, y, -1.0, 1.0);
    final rayEnd = Vector4(x, y, 1.0, 1.0);
    
    final inverseViewProj = camera.viewProjectionMatrix.clone()..invert();
    
    final worldStart = inverseViewProj * rayStart;
    worldStart.scale(1.0 / worldStart.w);
    
    final worldEnd = inverseViewProj * rayEnd;
    worldEnd.scale(1.0 / worldEnd.w);
    
    final direction = (worldEnd.xyz - worldStart.xyz)..normalize();
    
    // Plane y = 0
    if (direction.y.abs() < 0.000001) return null;
    
    final t = -worldStart.y / direction.y;
    if (t < 0) return null;
    
    return worldStart.xyz + (direction * t);
  }
}
