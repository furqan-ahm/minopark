import 'dart:async';

import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:get/get.dart';
import 'package:minopark/controllers/game_controller.dart';
import 'package:minopark/events/game_events.dart';
import 'package:minopark/game/actors/player.dart';
import 'package:minopark/game/maps/map_level.dart';

class MainGame extends Forge2DGame {
  // MainGame():super(gravity: Vector2.zero());

  Vector2 get gameSize => Vector2(30, 70);


  GameController get controller => Get.find<GameController>();

  MapLevel map = MapLevel(level: 1);

  late Vector2 spawnPos;
  late Vector2 playerSize;

  Map<String, Player> players = {};

  Player get player => players[controller.playerName.text]!;

  late SpriteSheet diceSprite;

  spawnPlayer(String playerName, {Vector2? size, Vector2? pos}) async{
    players[playerName] =
        Player(id: players.length, spawnPosition: pos??spawnPos, size: size??playerSize);
    await world.add(players[playerName]!);
    if (playerName == controller.playerName.text) {
      
      camera.follow(player);
    }
    return true;
  }

  @override
  FutureOr<void> onLoad() async {
    diceSprite = SpriteSheet(
        image: await images.load('diceSpriteSheet.png'),
        srcSize: Vector2(32, 32));

    
    await world.add(map);
    if(controller.isHost){
      spawnPlayer(controller.playerName.text);
    }


    return super.onLoad();
  }

  double timeSinceLastUpdate = 0;

  @override
  void update(double dt) {
    
    super.update(dt);
    controller.sendGameStateUpdate();
  }


  GameStateUpdateEvent currentState() {
    return GameStateUpdateEvent(
      playerStates: players.keys
          .map((e) {
            final bodyReady=players[e]!.isLoaded;
            return PlayerState(
              id: e,
              animState: bodyReady?players[e]!.currentAnim:PlayerAnimationState.standAnim,
              velocity: bodyReady?players[e]!.body.linearVelocity:Vector2.zero(),
              position: bodyReady?players[e]!.body.position:spawnPos);
          })
          .toList(),
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  void synchronizeState(GameStateUpdateEvent event) async{
    if(map.isLoaded&& isLoaded){
      for(var playerState in event.playerStates){
      if(players[playerState.id]==null){
        await spawnPlayer(playerState.id, pos: playerState.position);
      }
      final player=players[playerState.id]!;
      if(player.isLoaded){

      player.body.setTransform(playerState.position, player.body.angle);
      player.body.linearVelocity=playerState.velocity;
      player.playerAnim.animation=player.getAnimationFromState(playerState.animState);
      }
    }
    }
  }

  void handleInput(InputEvent event) {
    switch (event.input) {
      case InputStates.JUMP:
        players[event.playerId]!.jump();
        break;
      
      case InputStates.MoveLeftFalse:
        players[event.playerId]!.moveLeft=false;
        break;
      
      case InputStates.MoveLeftTrue:
        players[event.playerId]!.moveLeft=true;
        break;
      
      case InputStates.MoveRightFalse:
        players[event.playerId]!.moveRight=false;
        break;
      
      case InputStates.MoveRightTrue:
        players[event.playerId]!.moveRight=true;
        break;
      
      
      default:
    }
  }
}
