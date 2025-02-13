import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket? _socket;

  IO.Socket? get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io('http://192.168.1.108:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket?.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket?.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket?.on('nuevo-mensaje', (payload) {
      print("nuevo-mensaje: $payload");
    });
  }
}
