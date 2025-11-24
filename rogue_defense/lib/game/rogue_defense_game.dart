import 'dart:async';
import 'dart:ui' hide Image;

import 'package:flame/game.dart';
import 'package:flame_3d/game.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/resources.dart';
import 'package:flame_3d/camera.dart';
import 'package:flutter/material.dart' hide Texture, Image;

class RogueDefenseGame extends FlameGame3D<World3D, CameraComponent3D> {
  RogueDefenseGame()
      : super(
          world: World3D(clearColor: const Color(0xFF000000)),
          camera: CameraComponent3D(
            position: Vector3(0, 15, 15),
            target: Vector3.zero(),
            up: Vector3(0, 1, 0),
            fovY: 60,
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Basic lighting
    world.add(
      LightComponent.point(
        position: Vector3(-5, 10, 5),
        intensity: 50.0,
      ),
    );

    world.add(
      LightComponent.ambient(
        intensity: 0.2,
      ),
    );

    // Ground plane
    world.add(
      MeshComponent(
        mesh: CuboidMesh(
           size: Vector3(20, 0.2, 20),
           material: SpatialMaterial(albedoColor: const Color(0xFF444444)),
        ),
        position: Vector3(0, -1, 0),
      ),
    );

    // Defender placeholder
    world.add(
      MeshComponent(
        mesh: CuboidMesh(
          size: Vector3(1, 1, 1),
          material: SpatialMaterial(albedoColor: const Color(0xFF00FF00)),
        ),
        position: Vector3(0, 0, 4),
      ),
    );
  }
}
