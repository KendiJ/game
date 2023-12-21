import 'dart:async';

import 'package:adventures/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

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
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          add(player);
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          break;
        default:
      }
    }

    // add(Player(character: 'Virtual Guy'));

    return super.onLoad();
  }
}
