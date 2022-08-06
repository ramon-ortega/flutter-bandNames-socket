import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket? get socket => _socket;
  Function get emit => _socket!.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io(
      'http://172.17.0.1:3000/',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNewConnection()
          .setExtraHeaders({'foo': 'bar'})
          .build(),
    );
    _socket?.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket?.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print("Recibe el mensaje");
    //   print('nombre:' + payload['nombre']);
    //   print('mensaje:' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    // });
  }
}
