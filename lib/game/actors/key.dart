import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:minopark/game/actors/player.dart';
import 'package:minopark/game/main_game.dart';

class Key extends BodyComponent<MainGame> with ContactCallbacks {
  Key({required this.spawnPosition, required this.size});

  @override
  bool get renderBody => true;

  Player? connectedTo;

  @override
  // TODO: implement paint
  Paint get paint => super.paint..color = Colors.blue.withOpacity(0.4);

  Vector2 spawnPosition;
  Vector2 size;

  @override
  Body createBody() {
    Shape shape = PolygonShape()..setAsBoxXY(size.x / 4, size.y / 2.2);

    final bodyDef = BodyDef(
        userData: this,
        position: spawnPosition,
        fixedRotation: true,
        type: BodyType.dynamic,
        allowSleep: false,
        gravityScale: Vector2.zero());
    final fixtureDef = FixtureDef(
      shape,
      density: 0,
      isSensor: true,
      friction: 0,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  // @override
  // Future<void> onLoad() async {
  //   return super.onLoad();
  // }

  @override
  void update(double dt) {
    if (connectedTo != null) {
      body.setTransform(
          body.position.clone()..lerp(
              Vector2(connectedTo!.body.position.x,
                  connectedTo!.body.position.y / 1.025),
              0.1),
          // ..moveToTarget(
          //     Vector2(connectedTo!.body.position.x,
          //         connectedTo!.body.position.y / 1.025),
          //     0.1),
          angle);
    }
    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Player) {
      connectedTo ??= other;
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is Player) {}
    super.endContact(other, contact);
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
