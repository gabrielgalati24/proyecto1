import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/models/producto.dart';
import 'package:frontend_mobile/pages/chat_page.dart';
import 'package:frontend_mobile/pages/producto_editing_page.dart';
import 'package:frontend_mobile/services/api.dart';
// import 'package:carousel_slider/carousel_slider.dart';

import 'package:frontend_mobile/widgets/menu_drawer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProductoPage extends StatefulWidget {
  final Producto producto;
  ProductoPage({Key? key, required this.producto}) : super(key: key);
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  // dynamic id;
  final RoundedLoadingButtonController _btnControllerCrear =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnControllerEliminar =
      RoundedLoadingButtonController();
  bool edit = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(
          // title: Icon(Icons.mediation_rounded),
          actions: [
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.add_comment_rounded)),
            Divider(
              height: 10,
            )
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                productoid: widget.producto.id,
              ),
            ),
          );
        },
      ),
      drawer: MenuWidget(),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(widget.producto.nombre),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Hero(
                    tag: widget.producto.id,
                    child: widget.producto.imagen != ''
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    image: widget.producto.imagen,
                                  ),
                                ),
                              );

                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (_) {
                              //   return DetailScreen(
                              //     image:
                              //         'https://res.cloudinary.com/dsvkna2xa/image/upload/v1622740629/vzev0ejfspjsvjrhj7oc.jpg',
                              //   );
                              // }));
                            },
                            child: CachedNetworkImage(
                              height: 250,
                              width: 250,
                              imageUrl: widget.producto.imagen,
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                          )
                        : Image.asset('assets/images/noimage.jpg'),
                  ),
                  // QrImage(
                  //   data: widget.producto.id,
                  //   version: QrVersions.auto,
                  //   size: 200.0,
                  // ),
                ],
              ),
              !edit ? _primaryView(widget.producto) : _editView()
            ],
          ),
          // child: FutureBuilder(
          //   future: getDataAPi(),
          //   // initialData: InitialData,
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if (snapshot.hasData) {
          //       return Center(
          //         child: Row(
          //           children: [
          //             Container(
          //               padding: EdgeInsets.all(8.0),
          //               child: Column(
          //                 children: [
          //                   Center(
          //                       child: Container(
          //                           child: Text(snapshot.data.nombre))),
          //                   Hero(
          //                     tag: snapshot.data.id,
          //                     child: Center(
          //                       child: snapshot.data.imagen != ''
          //                           ? CachedNetworkImage(
          //                               height: 250,
          //                               width: 250,
          //                               imageUrl: snapshot.data.imagen,
          //                               placeholder: (context, url) =>
          //                                   new CircularProgressIndicator(),
          //                               errorWidget: (context, url, error) =>
          //                                   new Icon(Icons.error),
          //                             )
          //                           : Image.asset('assets/images/noimage.jpg'),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Divider(),
          //           ],
          //         ),
          //       );
          //     } else {
          //       return CircularProgressIndicator();
          //     }
          //   },
          // ),
        ),
      ),
    );
  }

  Widget _primaryView(Producto producto) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Text('Nombre'),
              Divider(),
              Text("                ${widget.producto.nombre}"),
            ],
          ),
          Column(
            children: [],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 150.0,
                height: 150.0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.green,
                          child: Text(
                            "data",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductoEditPage(
                                  producto: producto,
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    child: RoundedLoadingButton(
                      color: Colors.red,
                      child: Text('Eliminar',
                          style: TextStyle(color: Colors.white)),
                      controller: _btnControllerEliminar,
                      onPressed: () async {
                        var dio = Dio();
                        var response = await dio.delete(
                            '${urlApi}/api/producto/borrar',
                            data: {'id': widget.producto.id});
                        print("//*/*/*/*/* ${response}");
                        // _btnControllerCrear.stop();
                        // _btnControllerEliminar.success();
                        Navigator.pushNamed(context, 'all');
                        setState(() {
                          // _futureAlbum = createAlbum(_controller.text);
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _editView() {
    return Center(
      child: Row(
        children: [
          Row(
            children: [
              Text('sdsdnombre     '),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'no puede estar vacio';
                  }
                },
              ),
              Divider(),
              Text(widget.producto.nombre),
            ],
          ),
          Row(
            children: [
              Text('sdsdnombre     '),
              Divider(),
              Text(widget.producto.nombre),
            ],
          ),
          Row(
            children: [
              Text('sdsdnombre     '),
              Divider(),
              Text(widget.producto.nombre),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 150.0,
                height: 150.0,
                child: RoundedLoadingButton(
                  color: Colors.green,
                  child: Text('Editar', style: TextStyle(color: Colors.white)),
                  controller: _btnControllerCrear,
                  onPressed: () async {
                    setState(() {
                      // _futureAlbum = createAlbum(_controller.text);
                    });
                  },
                ),
              ),
              Container(
                width: 150.0,
                height: 150.0,
                child: RoundedLoadingButton(
                  color: Colors.red,
                  child:
                      Text('Eliminar', style: TextStyle(color: Colors.white)),
                  controller: _btnControllerEliminar,
                  onPressed: () async {
                    var dio = Dio();
                    var response = await dio.delete(
                        '${urlApi}/api/producto/borrar',
                        data: {'id': widget.producto.id});
                    print("//*/*/*/*/* ${response}");
                    _btnControllerCrear.stop();
                    _btnControllerEliminar.success();
                    setState(() {
                      // _futureAlbum = createAlbum(_controller.text);
                    });
                  },
                ),
              )
            ],
          )
        ],
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
  //     var response = await dio.post(
  //         'https://banckedqr.herokuapp.com/api/producto/pedir',
  //         data: {'id': widget.id});
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
}

class DetailScreen extends StatelessWidget {
  final String image;
  DetailScreen({Key? key, required this.image}) : super(key: key);
  // String? image;
  // DetailScreen({required image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(),
      body: ExtendedImage.network(
        image,
        fit: BoxFit.contain,
        //enableLoadState: false,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (state) {
          return GestureConfig(
            minScale: 0.9,
            animationMinScale: 0.7,
            maxScale: 3.0,
            animationMaxScale: 3.5,
            speed: 1.0,
            inertialSpeed: 100.0,
            initialScale: 1.0,
            inPageView: false,
            initialAlignment: InitialAlignment.center,
          );
        },
      ),
      // body: GestureDetector(
      //   child: Center(
      //     child: Hero(
      //       tag: 'imageHero',
      //       child: Image.network(
      //         image,
      //       ),
      //     ),
      //   ),
      //   // onTap: () {
      //   //   Navigator.pop(context);
      //   // },
      // ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const CustomAppBar({Key? key, required this.onTap, required this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  // TODO: implement preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
