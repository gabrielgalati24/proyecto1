import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_mobile/models/producto.dart';
import 'package:frontend_mobile/pages/producto_page.dart';
import 'package:frontend_mobile/services/api.dart';

import 'package:frontend_mobile/widgets/menu_drawer.dart';
import 'package:http/http.dart' as http;

class AllProdcutosPage extends StatefulWidget {
  dynamic id;
  AllProdcutosPage({Key? key, this.id = "woler"}) : super(key: key);
  @override
  _AllProdcutosPageState createState() => _AllProdcutosPageState();
}

class _AllProdcutosPageState extends State<AllProdcutosPage> {
  dynamic id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(),
      drawer: MenuWidget(),
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: fetchProductos(http.Client()),
            // initialData: InitialData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return snapshot.hasData
                    ? productosList(productos: snapshot.data!)
                    : Center(child: CircularProgressIndicator());
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  // Future<dynamic>? getDataAPi() async {
  //   print("/-----------/-/-/-/-/--//-/-/${widget.id}");
  //   var xxxxx = "60ad9324b0743a2ce87466f4";
  //   try {
  //     var dio = Dio();
  //     // var response = await Dio().post(
  //     //     "http://192.168.0.109:4001/api/producto/pedir",
  //     //     data: {"id": widget.id});
  //     // var response = await dio.post(
  //     //     'http://192.168.0.109:4001/api/producto/pedir',
  //     //     data: {id: "60ad9324b0743a2ce87466f4"});
  //     var response =
  //         await dio.get('http://192.168.0.109:4001/api/producto/all');
  //     final parsed = jsonDecode(response).cast<Map<dynamic, dynamic>>();
  //     print(response);
  //     print("1");
  //     final jsonResponse = json.decode(response.toString());
  //     print("2");
  //     dynamic data = new Producto.fromJson(jsonResponse);
  //     print(data);
  //     return data;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<List<Producto>> fetchProductos(http.Client client) async {
    final response = await client.get(Uri.parse('${urlApi}/api/producto/all'));

    print('//////////////////${response}');

    print('//////////////////${response.body}');

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Producto>((json) => Producto.fromJson(json)).toList();
    // Use the compute function to run parsePhotos in a separate isolate.
    // return compute(parseProductos, response.body);
    // var dio = Dio();
    // final response = await dio.post(
    //   'http://192.168.0.109:4001/api/producto/pedir',
    // );

    // // Use the compute function to run parseProductos in a separate isolate.
    // return compute(parseProductos, response.body);
  }

  List<Producto> parseProductos(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    var x = parsed.map<Producto>((json) => Producto.fromJson(json)).toList();

    return x;
  }
}

class productosList extends StatelessWidget {
  final List<Producto> productos;

  productosList({Key? key, required this.productos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(productos);
    if (productos.isEmpty) {
      return Center(child: Text("no hay equipos registrados"));
    } else {
      if (Platform.isWindows) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: productos.length,
          itemBuilder: (context, index) {
            return Container(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductoPage(
                              producto: productos[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        // padding: new EdgeInsets.all(32.0),
                        height: 350,
                        child: Card(
                          elevation: 10.0,
                          shadowColor: Colors.blueGrey,
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: [
                              Text(productos[index].nombre),
                              Hero(
                                tag: productos[index].id,
                                child: Center(
                                  child: productos[index].imagen != ''
                                      ? CachedNetworkImage(
                                          height: 300,
                                          width: 320,
                                          imageUrl: productos[index].imagen,
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        )
                                      : Image.asset(
                                          'assets/images/noimage.jpg'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  // Card(child: Center(child: Text(productos[index].nombre!))),
                  // Center(
                  //   child: Image.network(
                  //     productos[index].imagen!,
                  //     height: 250,
                  //   ),
                  // )
                ],
              ),
            );
          },
        );
      } else {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          itemCount: productos.length,
          itemBuilder: (context, index) {
            return Container(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductoPage(
                              producto: productos[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        // padding: new EdgeInsets.all(32.0),
                        height: 350,
                        child: Card(
                          elevation: 10.0,
                          shadowColor: Colors.blueGrey,
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: [
                              Text(productos[index].nombre),
                              Hero(
                                tag: productos[index].id,
                                child: Center(
                                  child: productos[index].imagen != ''
                                      ? CachedNetworkImage(
                                          height: 300,
                                          width: 320,
                                          imageUrl: productos[index].imagen,
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        )
                                      : Image.asset(
                                          'assets/images/noimage.jpg'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  // Card(child: Center(child: Text(productos[index].nombre!))),
                  // Center(
                  //   child: Image.network(
                  //     productos[index].imagen!,
                  //     height: 250,
                  //   ),
                  // )
                ],
              ),
            );
          },
        );
      }
    }
  }
}
