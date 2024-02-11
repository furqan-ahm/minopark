import 'dart:async';

import 'package:minopark/constants.dart';
import 'package:minopark/events/game_events.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ClientService {
  late Socket socket;
  String playerName;
  int clientTimeOffset = 0;

  final List pingDelays = [];

  ClientService.connect(String address, {required this.playerName}) {
    socket = io(
      'http://$address:3000',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect()
          .build(),
    );

    socket.onError((data) => print(data));

    socket.on('gameState', (data) {
      eventBus.fire(GameStateUpdateEvent.fromJson(data));
    });
    socket.on('pong1', (data) {
      var delay = (DateTime.now().millisecondsSinceEpoch - data['time']) ~/ 2;
      pingDelays.add(delay);
    });

    socket.on('ready', (data) {});

    socket.onConnect((data) {
      pingServer();
    });

    // socket.on('pingm', (data) => socket.emit('pingS', data));

    socket.on('joinGame', (data) {
      // Calculate the client time offset based on the server's offset
      pingDelays.removeAt(0);
      int averagePing =
          pingDelays.reduce((value, element) => value + element) ~/
              pingDelays.length;
      clientTimeOffset = DateTime.now().millisecondsSinceEpoch -
          (data['offset'] as int) -
          averagePing;
      eventBus.fire(JoinedGameEvent());
    });

    // pingServer();
    socket.connect();
  }

  pingServer() {
    int count = 0;
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      Map data = {'id': count, 'time': DateTime.now().millisecondsSinceEpoch};

      count++;
      socket.emit('ping1', data);
      if (count > 100) {
        timer.cancel();
        socket.emit('ready', {
          'playerName': playerName,
        });
      }
    });
  }

  sendInput(InputStates input) {
    socket.emit('inputEvent', {'id': playerName, 'input': input.index});
  }

  // sendPlayerMovementInfo(PlayerMovementEvent event){
  //   socket.emit('playerMovement', event.toJson());
  // }

  dispose() {
    socket.close();
  }
}
