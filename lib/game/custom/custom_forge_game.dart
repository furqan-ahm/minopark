// import 'package:flame_forge2d/flame_forge2d.dart';
// import 'package:flutter/material.dart';

// class CustomForge2DGame extends Forge2DGame {
//   static const minDt = 1 / 60; // 30 fps
//   double dtOverflow = 0;

//   @override
//   @mustCallSuper
//   bool update(double dt) {
//     dtOverflow += dt;
//     if (dtOverflow < minDt) {
//       return false;
//     }
//     if (parent == null) {
//       updateTree(dtOverflow);
//     }
//     camera.update(dtOverflow);
//     dtOverflow = 0;
//     return true;
//   }
// }
