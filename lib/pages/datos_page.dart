import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatosPage extends StatelessWidget {
  const DatosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = new LocalStorage('todo_app');
    pp() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = (prefs.getString('token') ?? '');
      print('\\\\\\\\\\\\\\\\\\\\\\\\\ $token');
      if (token == '') {
        Navigator.pushReplacementNamed(context, 'login');
      } else {
        Navigator.pushReplacementNamed(context, 'all');
      }
    }

    pp(); // storage.setItem("token", "woler");
    // var token = storage.getItem('token');
    // print('//////////// $token');
    // if (token == false || token == null) {
    //   Navigator.pushReplacementNamed(context, 'login');
    // } else {
    //   Navigator.pushReplacementNamed(context, 'all');
    // }
    return Container();
  }
}
