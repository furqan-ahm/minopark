import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:minopark/constants.dart';
import 'package:minopark/events/game_events.dart';
import 'package:minopark/game/components/platform.dart';
import 'package:minopark/game/main_game.dart';

enum PlayerAnimationState { runAnim, jumpUpAnim, jumpDownAnim, standAnim }

class Player extends BodyComponent<MainGame> with ContactCallbacks {
  Player({required this.id, required this.spawnPosition, required this.size});

  @override
  bool get renderBody => false;

  Vector2 spawnPosition;
  Vector2 size;
  int id;

  double moveSpeed = 6;

  bool moveLeft = false;
  bool moveRight = false;

  bool canJump = false;

  late SpriteAnimationComponent playerAnim;

  late SpriteAnimation runAnim;
  late SpriteAnimation jumpUpAnim;
  late SpriteAnimation jumpDownAnim;
  late SpriteAnimation standAnim;

  // List<Player> topContactPlayers=[];

  Player? bottomContactPlayer;

  SpriteAnimation getAnimationFromState(PlayerAnimationState state){
    switch (state) {
      case PlayerAnimationState.runAnim:
        return runAnim;
      default:
        return standAnim;
    }
  }

  PlayerAnimationState get currentAnim {
    if (playerAnim.animation == runAnim) {
      return PlayerAnimationState.runAnim;
    } else if (playerAnim.animation == jumpUpAnim) {
      return PlayerAnimationState.jumpUpAnim;
    } else if (playerAnim.animation == jumpDownAnim) {
      return PlayerAnimationState.jumpDownAnim;
    } else return PlayerAnimationState.standAnim;
  }

  jump() {
    if (canJump) {
      canJump = false;
      body.applyLinearImpulse(Vector2(0, -30));
    }
  }

  @override
  Body createBody() {
    Shape shape = PolygonShape()..setAsBoxXY(size.x / 4, size.y / 2.2);

    final bodyDef = BodyDef(
      userData: this,
      position: spawnPosition,
      fixedRotation: true,
      type: BodyType.dynamic,
      allowSleep: false,
    );
    final fixtureDef = FixtureDef(
      shape,
      friction: 0,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  bool get facingRightSide => !playerAnim.isFlippedHorizontally;

  setUpAnimListeners() {
    if (game.player == this) {
      eventBus.on<InputEvent>().listen((event) {
        if (event.playerId == game.controller.playerName.text) {
          switch (event.input) {
            case InputStates.MoveRightTrue:
              if (!facingRightSide) playerAnim.flipHorizontally();
              playerAnim.animation = runAnim;
              break;

            case InputStates.MoveRightFalse:
              playerAnim.animation = standAnim;
              break;
            case InputStates.MoveLeftFalse:
              playerAnim.animation = standAnim;
              break;

            case InputStates.MoveLeftTrue:
              if (facingRightSide) playerAnim.flipHorizontally();
              playerAnim.animation = runAnim;
              break;
            default:
          }
        }
      });
    }
  }

  initSpriteAnims() async {
    Image spriteSheet = await game.images.load('playerSpriteSheet.png');

    standAnim = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            amount: 8, stepTime: 0.2, textureSize: Vector2.all(50)));
    runAnim = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            amount: 9,
            stepTime: 0.1,
            textureSize: Vector2.all(50),
            texturePosition: Vector2(0, 50)));
    jumpUpAnim = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            amount: 1,
            stepTime: 0.1,
            textureSize: Vector2.all(50),
            texturePosition: Vector2(0, 100)));
    jumpDownAnim = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            amount: 9,
            stepTime: 0.1,
            textureSize: Vector2.all(50),
            texturePosition: Vector2(1, 100)));
  }

  handleRemotePlayerAnim() {
    if (game.player != this) {
      if (body.linearVelocity.x > 0) {
        if (!facingRightSide) playerAnim.flipHorizontally();
        if (playerAnim.animation != runAnim) playerAnim.animation = runAnim;
      } else if (body.linearVelocity.x < 0) {
        if (facingRightSide) playerAnim.flipHorizontally();
        if (playerAnim.animation != runAnim) playerAnim.animation = runAnim;
      } else {
        if (playerAnim.animation != standAnim) playerAnim.animation = standAnim;
      }
    }
  }

  @override
  Future<void> onLoad() async {
    // add(SpriteComponent(sprite: game.diceSprite.getSprite(0, 0), size: size, anchor: Anchor.center));

    await initSpriteAnims();

    playerAnim = SpriteAnimationComponent(
        animation: standAnim,
        anchor: Anchor.center,
        size: size,
        position: Vector2(0, -size.y * 0.0216));
    add(playerAnim);
    setUpAnimListeners();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.controller.isHost) {
      if (moveLeft || (bottomContactPlayer?.moveLeft ?? false)) {
        body.linearVelocity = Vector2(-moveSpeed, body.linearVelocity.y);
        // body.applyLinearImpulse(Vector2(-moveSpeed/2, 0));
      } else if (moveRight || (bottomContactPlayer?.moveRight ?? false)) {
        body.linearVelocity = Vector2(moveSpeed, body.linearVelocity.y);
        // body.applyLinearImpulse(Vector2(moveSpeed/2, 0));
      } else {
        body.linearVelocity = Vector2(0, body.linearVelocity.y);
      }
    }
    // body.linearVelocity=body.linearVelocity.clone()..clamp(Vector2(-moveSpeed, double.negativeInfinity), Vector2(moveSpeed, double.infinity));
    // print(bottomContactPlayer?.body.linearVelocity);
    // if (isLoaded) handleRemotePlayerAnim();
    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Platform) {
      canJump = true;
    }
    if (other is Player) {
      canJump = true;
      if (((body.position.y - other.body.position.y) + size.y).abs() <
              0.00000001 &&
          body.position.y < other.body.position.y) {
        // if(game.player==this)print((body.position.y-other.body.position.y)-size.y);
        bottomContactPlayer = other;
      }
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    // TODO: implement endContact
    if (other is Player) {
      if (other == bottomContactPlayer) {
        bottomContactPlayer = null;
      }
    }
    super.endContact(other, contact);
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
