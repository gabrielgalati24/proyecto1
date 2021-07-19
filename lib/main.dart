import 'package:flutter/material.dart';
import 'package:frontend_mobile/pages/all_productos_page.dart';
import 'package:frontend_mobile/pages/chat_page.dart';
import 'package:frontend_mobile/pages/datos_page.dart';
import 'package:frontend_mobile/pages/login_page.dart';
import 'package:frontend_mobile/pages/producto_page.dart';
import 'package:frontend_mobile/pages/pruebas_page.dart';
import 'package:frontend_mobile/pages/qr_reader_page.dart';
import 'package:frontend_mobile/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // connec();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      // home: AllProdcutosPage(),
      home: DatosPage(),
      // initialRoute:LoginPage() ,
      routes: {
        // 'chat': (_) => ChatPage(),
        'all': (_) => AllProdcutosPage(),
        'login': (_) => LoginPage(),
        'qr_reader': (_) => QrReaderPage(),
        'pruebas': (_) => PruebasPage(),
        'datos': (_) => DatosPage()
        // 'productos': (_) => ProductoPage()
      },
    );
  }
}
