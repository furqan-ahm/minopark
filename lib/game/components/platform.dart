
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';


class Platform extends BodyComponent with ContactCallbacks{


  Platform({
    required this.position,
    required this.size,
  }): super(priority: -1);


  
  Vector2 position;
  Vector2 size;


  @override
  bool get renderBody => true;
  

    @override
  // TODO: implement paint
    // Paint get paint => super.paint..color=Colors.black;


  @override
  Body createBody() {
    Shape shape=PolygonShape()..setAsBoxXY(size.x/2, size.y/2);
    BodyDef bodyDef= BodyDef(position: position+Vector2(size.x/2, size.y/2), type: BodyType.static, userData: this);
    FixtureDef fixtureDef = FixtureDef(shape, friction: 0, density: 1, restitution: 0);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

}