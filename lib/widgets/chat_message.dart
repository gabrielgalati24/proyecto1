import 'package:flutter/material.dart';
// import 'package:mobile_flutter/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final String? texto;
  final String? id;
  final String? uid;

  const ChatMessage({
    Key? key,
    @required this.id,
    @required this.texto,
    @required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context, listen: false);

    return Container(
      child: this.id == this.uid ? _myMessage() : _notMyMessage(),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(right: 5, bottom: 5, left: 50),
        child: Text(
          this.texto!,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color(0xff4D9EF6), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(left: 5, bottom: 5, right: 50),
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'Prueba:',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              this.texto!,
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Color(0xffE4E5E8), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
