import 'dart:async';
import 'dart:ui';

import 'package:minopark/game/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../actors/player.dart';
import '../components/platform.dart';

class MapLevel extends Component with HasGameRef<MainGame> {
  MapLevel({required this.level}) : super();

  int level;

  late Vector2 mapSize;
  
  @override
  FutureOr<void> onLoad() async {
    TiledComponent map = await TiledComponent.load(
        'map$level.tmx', Vector2.all(32) / 10,
        priority: 20);
    // add(map);
    mapSize = map.scaledSize;

    final spawnLayer = map.tileMap.getLayer<ObjectGroup>('spawn');

    final platformLayer = map.tileMap.getLayer<ObjectGroup>('platforms');

    for (final platform in platformLayer!.objects) {
      game.world.add(Platform(
        position: Vector2(platform.x / 10, platform.y / 10),
        size: Vector2(platform.width / 10, platform.height / 10),
      ));
    }

    for (final spawn in spawnLayer!.objects) {
      if (spawn.class_ == 'player') {
        
        game.playerSize=Vector2(spawn.width / 10, spawn.height / 10) * 0.8;
        game.spawnPos=Vector2(spawn.x / 10, spawn.y / 10);
        // game.camera.follow(player);
      }
    }

    game.camera.viewfinder.zoom = 20;

    // game.player?.cameraFollow();
    return super.onLoad();
  }


  

}
