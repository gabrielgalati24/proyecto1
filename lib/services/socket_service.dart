import 'package:frontend_mobile/services/api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

void SocketService() {
  // Dart client

  IO.Socket socket = IO.io(urlApi);
  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });
  socket.on('event', (data) => print(data));
  socket.onDisconnect((_) => print('disconnect'));
  socket.on('fromServer', (_) => print(_));
}

void connec() {
  Socket socket = io(
      urlApi,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableAutoConnect()
          .enableForceNew()
          .build());
  socket.connect();
  // socket.on('connection', (_) {});
  socket.on('woler', (data) {
    print(data);
  });
  socket.emit('woler1', (1));
}






// import 'package:flutter/material.dart';
// import 'package:mobile_flutter/global/environment.dart';
// import 'package:mobile_flutter/services/auth_service.dart';

// import 'package:socket_io_client/socket_io_client.dart' as IO;

// enum ServerStatus { Online, Offline, Connecting }

// class SocketService with ChangeNotifier {
//   ServerStatus _serverStatus = ServerStatus.Connecting;
//   IO.Socket? _socket =

//   ServerStatus get serverStatus => this._serverStatus;

//   IO.Socket get socket => this._socket;
//   Function get emit => this._socket.emit;

//   void connect() async {
//     final token = await AuthService.getToken();

//     // Dart client
//     this._socket = IO.io(Environment.socketUrl, {
//       'transports': ['websocket'],
//       'autoConnect': true,
//       'forceNew': true,
//       'extraHeaders': {'x-token': token}
//     });

//     this._socket.on('connect', (_) {
//       this._serverStatus = ServerStatus.Online;
//       notifyListeners();
//     });

//     this._socket.on('disconnect', (_) {
//       this._serverStatus = ServerStatus.Offline;
//       notifyListeners();
//     });
//   }

//   void disconnect() {
//     this._socket.disconnect();
//   }
// }
