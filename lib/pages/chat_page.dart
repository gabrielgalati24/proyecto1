import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/services/api.dart';
import 'package:frontend_mobile/widgets/chat_message.dart';
import 'package:frontend_mobile/widgets/menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
// import 'package:mobile_flutter/models/mensajes_response.dart';
// import 'package:mobile_flutter/services/auth_service.dart';
// import 'package:mobile_flutter/services/chat_service.dart';
// import 'package:mobile_flutter/services/socket_service.dart';
// import 'package:mobile_flutter/widgets/chat_message.dart';
// import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String productoid;
  ChatPage({Key? key, required this.productoid}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> mes = [];
  Socket? socket;
  String? token;
  void connec() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('id') ?? '');

    socket = io(
        urlApi,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew()
            .build());
    socket!.connect();
    // socket.on('connection', (_) {});
    socket!.on(widget.productoid, (data) {
      ChatMessage message = new ChatMessage(
        id: data['de'],
        texto: data['mensaje'],
        uid: token,
      );
      // print('////////////// $data');
      mes.insert(0, message);
      setState(() {});
    });
  }

  void cargarchat() async {
    Response response;

    var dio = Dio();
    response = await dio
        .post('$urlApi/api/mensajes/obtener', data: {'id': widget.productoid});
    // print(response.data);
    var chat = response.data;
    // print("$chat ////////");
    List chat2 = chat['mensajes'];
    print("hola");
    for (var i = 0; i < chat2.length; i++) {
      print('holaaaa');
      mes.insert(
          0,
          ChatMessage(
            id: chat2[i]['de'],
            texto: chat2[i]['mensaje'],
            uid: token,
          ));
    }
    // final history = chat2.map((m) => {
    //       //  mes.insert(0, m);
    //       print("hola2"),
    //       mes.insert(
    //           0,
    //           ChatMessage(
    //             id: m['de'],
    //             texto: m['mensaje'],
    //             uid: token,
    //           )),
    //     });
    setState(() {});
  }
  // ChatService chatService;
  // SocketService socketService;
  // AuthService authService;

  // List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    cargarchat();
    connec();
    // this.chatService = Provider.of<ChatService>(context, listen: false);
    // this.socketService = Provider.of<SocketService>(context, listen: false);
    // this.authService = Provider.of<AuthService>(context, listen: false);

    // this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    // _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    // List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    // final history = chat.map((m) => new ChatMessage(
    //       texto: m.mensaje,
    //       uid: m.de,
    //       animationController: new AnimationController(
    //           vsync: this, duration: Duration(milliseconds: 0))
    //         ..forward(),
    //     ));

    // setState(() {
    //   _messages.insertAll(0, history);
    // });
  }

  // void _escucharMensaje(dynamic payload) {
  //   ChatMessage message = new ChatMessage(
  //     texto: payload['mensaje'],
  //     uid: payload['de'],
  //     animationController: AnimationController(
  //         vsync: this, duration: Duration(milliseconds: 300)),
  //   );

  //   setState(() {
  //     _messages.insert(0, message);
  //   });

  //   message.animationController.forward();
  // }

  @override
  Widget build(BuildContext context) {
    // final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      // drawer: MenuWidget(),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          children: <Widget>[
            // Hero(
            //   tag: 'w',
            //   child: CircleAvatar(
            //     child: Hero(
            //       tag: 'w',
            //       child: Text('woler', style: TextStyle(fontSize: 12)),
            //     ),
            //     backgroundColor: Colors.blue[100],
            //     maxRadius: 14,
            //   ),
            // ),
            SizedBox(height: 3),
            Text('chat', style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // Flexible(child: Container()),
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: mes.length,
              itemBuilder: (_, i) => mes[i],
              // itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),

            Divider(height: 1),

            // TODO: Caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
            controller: _textController,
            // onSubmitted: _handleSubmit,
            onChanged: (texto) {
              setState(() {
                if (texto.trim().length > 0) {
                  _estaEscribiendo = true;
                } else {
                  _estaEscribiendo = false;
                }
              });
            },
            decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            focusNode: _focusNode,
          )),

          // Botón de enviar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: () {},
                    // onPressed: _estaEscribiendo
                    //     ? () => _handleSubmit(_textController.text.trim())
                    //     : null,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: () {
                          socket!.emit('woler1', {
                            'de': token,
                            'para': widget.productoid,
                            'mensaje': _textController.text.trim()
                          });
                          _textController.text = '';
                          // print(' assaas');
                          // mes.insert(
                          //     0,
                          //     ChatMessage(
                          //       texto: _textController.text.trim(),
                          //       uid: 'woelr',
                          //     ));
                          setState(() {});
                        },
                        // onPressed: _estaEscribiendo
                        //     ? () => _handleSubmit(_textController.text.trim())
                        //     : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  // _handleSubmit(String texto) {
  //   if (texto.length == 0) return;

  //   _textController.clear();
  //   _focusNode.requestFocus();

  //   final newMessage = new ChatMessage(
  //     uid: authService.usuario.uid,
  //     texto: texto,
  //     animationController: AnimationController(
  //         vsync: this, duration: Duration(milliseconds: 200)),
  //   );
  //   _messages.insert(0, newMessage);
  //   newMessage.animationController.forward();

  //   setState(() {
  //     _estaEscribiendo = false;
  //   });

  //   this.socketService.emit('mensaje-personal', {
  //     'de': this.authService.usuario.uid,
  //     'para': this.chatService.usuarioPara.uid,
  //     'mensaje': texto
  //   });
  // }

  // @override
  // void dispose() {
  //   for (ChatMessage message in _messages) {
  //     message.animationController.dispose();
  //   }

  //   this.socketService.socket.off('mensaje-personal');
  //   super.dispose();
  // }
}

/*eliminar*/

