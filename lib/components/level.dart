import 'dart:async';

import 'package:adventures/components/collision_block.dart';
import 'package:adventures/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  List<CollisionBlock> collisionBlocks = [];

  late TiledComponent level;
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      // '$levelName.tmx'
      'level-01.tmx',
      Vector2.all(16),
    );
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            add(player);
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            break;
          default:
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    // add(Player(character: 'Virtual Guy'));

    return super.onLoad();
  }
}
