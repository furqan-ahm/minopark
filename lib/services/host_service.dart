import 'package:bonsoir/bonsoir.dart';
import 'package:minopark/constants.dart';
import 'package:minopark/events/game_events.dart';
import 'package:socket_io/socket_io.dart';
// import 'package:socket_io_client/socket_io_client.dart' as client;

class HostServer {
  Server? server;

  static HostServer? _instance;

  bool otherPlayerJoined = false;

  static HostServer get instance {
    return _instance ??= HostServer._();
  }

  late BonsoirService service;
  BonsoirBroadcast? broadcast;

  HostServer._() {
    server ??= Server();

    server!.on('connection', (client) {
      print('connected to $client');

      client.on('playerMovement', (data) {
        // eventBus.fire(PlayerMovementEvent.fromJson(data));
      });

      client.on('ready', (data) {});

      client.on('ping1', (data) {
        client.emit('pong1', data);
      });

      client.on('ready', (data) {
        eventBus.fire(PlayerJoinedEvent(name: data['playerName']));
        client.emit(
            'joinGame', {'offset': DateTime.now().millisecondsSinceEpoch});
      });

      client.on('inputEvent', (data) {
        eventBus.fire(InputEvent.fromJson(data));
      });
      // eventBus.fire(GameStartEvent());
    });
  }

  broadcastServer(String name) async {
    service = BonsoirService(
      name: name,
      type: '_multiplayertest._tcp',
      port: 3030,
    );
    broadcast = BonsoirBroadcast(service: service);
  }

  start(String name) async {
    broadcastServer(name);
    await broadcast!.ready;
    print('Starting Server');
    server?.listen(3000);
    broadcast!.start();
  }

  stop() {
    print('Stopping Server');
    server?.close();
    broadcast?.stop();
    print('Server Stopped');
  }

  void sendGameState(GameStateUpdateEvent event) {
    server?.emit('gameState', event.toJson());
  }
}
