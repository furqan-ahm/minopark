import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minopark/constants.dart';
import 'package:minopark/events/game_events.dart';
import 'package:minopark/game/main_game.dart';
import 'package:minopark/services/host_service.dart';
import 'package:minopark/ui/loading_screen.dart';
import 'package:wakelock/wakelock.dart';

import '../services/client_service.dart';
import '../ui/game_screen.dart';

class GameController extends GetxController {
  TextEditingController playerName = TextEditingController();

  ClientService? client;
  double updateInterval = 0.1;
  late Timer gameStateUpdateTimer;

  MainGame? game;
  bool isHost = false;

  @override
  void onInit() {
    Wakelock.enable();
    playerName.text = "Player ${nouns.random().capitalizeFirst}";
    addEventHandlers();
    super.onInit();
  }

  startClient(String address) {
    client?.dispose();
    client = ClientService.connect(address, playerName: playerName.text);
  }

  addEventHandlers() {
    eventBus.on<PlayerJoinedEvent>().listen((event) {
      game?.spawnPlayer(event.name);
    });

    eventBus.on<GameStateUpdateEvent>().listen((event) {
      game?.synchronizeState(event);
    });

    eventBus.on<InputEvent>().listen((event) {
      if (isHost) {
        game?.handleInput(event);
      }
    });

    eventBus.on<JoinedGameEvent>().listen((event) {
      game = MainGame();
      Get.off(const GameScreen());
    });
  }

  sendGameStateUpdate() {
    if (isHost) {
      HostServer.instance.sendGameState(game!.currentState());
    }
  }

  hostGame() {
    isHost = true;

    HostServer.instance.start(playerName.text);
    game = MainGame();
    Get.to(const GameScreen())?.then((value) {
      HostServer.instance.stop();
    });
  }

  joinGme({required String address}) {
    startClient(address);
    Get.to(const LoadingScreen());
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  playerInput(InputStates input) {
    if (!isHost) {
      client?.sendInput(input);
    }
    eventBus.fire(InputEvent(input: input, playerId: playerName.text));
  }
}
