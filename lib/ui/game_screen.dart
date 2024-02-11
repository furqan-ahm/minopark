import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minopark/controllers/game_controller.dart';
import 'package:minopark/events/game_events.dart';
import 'package:minopark/game/main_game.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  MainGame get game => controller.game!;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, _) {
      return RotatedBox(
          quarterTurns: MediaQuery.of(context).size.height >
                  MediaQuery.of(context).size.width
              ? 1
              : 0,
          child: Stack(
            children: [
              GameWidget(game: game),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 42.0, vertical: 64),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Material(
                      color: Colors.white.withOpacity(0.85),
                      elevation: 0,
                      child: InkWell(
                        onTapDown: (det) {
                          controller.playerInput(InputStates.JUMP);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Icon(Icons.waves),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 42.0, vertical: 64),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Material(
                            color: Colors.blue.shade900.withOpacity(0.85),
                            elevation: 0,
                            child: InkWell(
                              onTapDown: (det) {
                                controller
                                    .playerInput(InputStates.MoveLeftTrue);
                              },
                              onTapUp: (det) {
                                controller
                                    .playerInput(InputStates.MoveLeftFalse);
                              },
                              onTapCancel: () {
                                controller
                                    .playerInput(InputStates.MoveLeftFalse);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.arrow_back_ios_rounded),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Material(
                            color: Colors.blue.shade900.withOpacity(0.85),
                            elevation: 0,
                            child: InkWell(
                              onTapDown: (det) {
                                controller
                                    .playerInput(InputStates.MoveRightTrue);
                              },
                              onTapUp: (det) {
                                controller
                                    .playerInput(InputStates.MoveRightFalse);
                              },
                              onTapCancel: () {
                                controller
                                    .playerInput(InputStates.MoveRightFalse);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ));
    });
  }
}
