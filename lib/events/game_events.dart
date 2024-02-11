import 'package:flame/game.dart';
import 'package:minopark/game/actors/player.dart';

//events
class GameStateUpdateEvent {
  List<PlayerState> playerStates;
  int timestamp;

  GameStateUpdateEvent({required this.playerStates, required this.timestamp});

  factory GameStateUpdateEvent.fromJson(Map<String, dynamic> json) {
    List<PlayerState> players = (json['playerStates'] as List)
        .map((playerData) => PlayerState.fromJson(playerData))
        .toList();

    return GameStateUpdateEvent(
      playerStates: players,
      timestamp: json['timestamp'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerStates': playerStates.map((player) => player.toJson()).toList(),
      'timestamp': timestamp,
    };
  }
}


// class GameStartEvent {}
class JoinedGameEvent{}


class PlayerJoinedEvent{
  String name;
  PlayerJoinedEvent({required this.name});
}


class InputEvent{
  String playerId;
  InputStates input;


  InputEvent({required this.input, required this.playerId});

  factory InputEvent.fromJson(data){
    return InputEvent(input: InputStates.values[data['input']], playerId: data['id']);
  }
}


//states





enum InputStates{MoveLeftTrue, MoveLeftFalse, MoveRightTrue, MoveRightFalse, JUMP}



class GameState{
  List<PlayerState> playerStates;
  
  GameState({required this.playerStates});

}

class PlayerState {
  String id;
  Vector2 velocity;
  Vector2 position;
  PlayerAnimationState animState;

  PlayerState({required this.id, required this.velocity, required this.position, required this.animState});

  factory PlayerState.fromJson(Map<String, dynamic> json) {
    return PlayerState(
      id: json['id'] as String,
      animState: PlayerAnimationState.values[json['animState'] as int],
      velocity: Vector2(json['velocityX'],json['velocityY']),
      position: Vector2(json['positionX'], json['positionY']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animState':animState.index,
      'velocityX':velocity.x, 
      'velocityY':velocity.y, 
      'positionX': position.x,
      'positionY': position.y,
    };
  }
}