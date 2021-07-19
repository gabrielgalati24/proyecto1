import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/producto.dart';
import 'package:frontend_mobile/services/api.dart';
import 'package:frontend_mobile/widgets/menu_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProductoEditPage extends StatefulWidget {
  final Producto producto;
  ProductoEditPage({Key? key, required this.producto}) : super(key: key);

  @override
  _ProductoEditPageState createState() => _ProductoEditPageState();
}

class _ProductoEditPageState extends State<ProductoEditPage> {
  File? _image;
  final picker = ImagePicker();
  bool image = false;
  TextEditingController displayNameController = TextEditingController();

  TextEditingController bioController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  void initState() {
    bioController.text = widget.producto.nombre;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: MenuWidget(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: widget.producto.id,
                  child: widget.producto.imagen != ''
                      ? CachedNetworkImage(
                          height: 250,
                          width: 250,
                          imageUrl: widget.producto.imagen,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        )
                      : Image.asset('assets/images/noimage.jpg'),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 0, right: 100),
                //   child: Row(
                //     children: [
                //       CircleAvatar(
                //         backgroundColor: Colors.blue,
                //         radius: 25.0,
                //         child: Icon(Icons.camera_alt, color: Colors.white),
                //       )
                //     ],
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                    "Nombre",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextField(
                  controller: bioController,
                  decoration: InputDecoration(
                    hintText: "Nombre vio",
                    // errorText: _bioValid ? null : "Bio too long",
                  ),
                ),
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: RoundedLoadingButton(
                    child: Text('Actualizar',
                        style: TextStyle(color: Colors.white)),
                    controller: _btnController,
                    onPressed: () async {
                      await _actualizarEquipo(_image, bioController.text);
                      Navigator.pushReplacementNamed(context, 'all');
                      _btnController.success();
                      setState(() {
                        // _futureAlbum = createAlbum(_controller.text);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _actualizarEquipo(File? file, String tex) async {
    FormData data;
    if (file == null) {
      data = FormData.fromMap({
        "id": widget.producto.id,
        "nombre": tex,
      });
    } else {
      String fileName = file.path.split('/').last;
      data = FormData.fromMap({
        "id": widget.producto.id,
        "nombre": tex,
        "image": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
    }
    // print(data.toString());
    Dio dio = new Dio();

    await dio
        .put("${urlApi}/api/producto", data: data)
        .then((response) => print(response))
        .catchError((error) => print(error));
  }
}
