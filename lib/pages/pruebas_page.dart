// import 'dart:async';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:frontend_mobile/widgets/menu_drawer.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:frontend_mobile/services/api.dart';

// Future<Album> createAlbum(
//   String title,
// ) async {
//   // var stream =
//   //     new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//   // // get file length
//   // var length = await imageFile.length();

//   // // string to uri
//   // var uri = Uri.parse("http://ip:8082/composer/predict");

//   // // create multipart request
//   // var request = new http.MultipartRequest("POST", uri);

//   // // multipart that takes file
//   // var multipartFile = new http.MultipartFile('file', stream, length,
//   //     filename: basename(imageFile.path));

//   String url = 'banckedqr.herokuapp.com';
//   var req = http.MultipartRequest('POST', Uri.parse(url));
//   final response = await http.post(
//     // Uri.https('jsonplaceholder.typicode.com', 'albums'),
//     Uri.https('banckedqr.herokuapp.com', '/api/pruebas'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'title': title,
//     }),
//   );

//   if (response.statusCode == 201) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create album.');
//   }
// }

// Future<String?> uploadImage(filename, url) async {
//   var request = http.MultipartRequest('POST', Uri.parse(url));
//   request.files.add(await http.MultipartFile.fromPath('picture', filename));
//   var res = await request.send();
//   return res.reasonPhrase;
// }

class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

class PruebasPage extends StatefulWidget {
  PruebasPage({Key? key}) : super(key: key);

  // String url = 'https://banckedqr.herokuapp.com/api/pruebas';
  @override
  _PruebasPageState createState() {
    return _PruebasPageState();
  }
}

Future _upload(File? file, String tex) async {
  // String fileName = file.path.split('/').last;

  // FormData data = FormData.fromMap({
  //   "nombre": tex,
  //   "image": await MultipartFile.fromFile(
  //     file.path,
  //     filename: fileName,
  //   ),
  // });
  FormData data;
  if (file == null) {
    data = FormData.fromMap({
      "nombre": tex,
    });
  } else {
    String fileName = file.path.split('/').last;
    data = FormData.fromMap({
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
      .post("${urlApi}/api/producto/crear", data: data)
      .then((response) => print(response))
      .catchError((error) => print(error));
}

class _PruebasPageState extends State<PruebasPage> {
  PickedFile? _imageFile;
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;
  File? _image;
  final picker = ImagePicker();
  bool image = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          // final file = await picker.getImage(source: ImageSource.camera);
          // var res = await uploadImage(file?.path, widget.url);
          // File _image;
          // final picker = ImagePicker();

          if (Platform.isWindows) {
            final file = OpenFilePicker()
              ..filterSpecification = {
                'Image (*.jpg;*.png)': '*.jpg;*png',
                // 'Web Page (*.htm; *.html)': '*.htm;*.html',
                // 'Text Document (*.txt)': '*.txt',
                'All Files': '*.*'
              }
              ..defaultFilterIndex = 0
              // ..defaultExtension = 'doc'
              ..title = 'Select a document';

            final result = file.getFile();
            if (result != null) {
              print(result.path);
              _image = File(result.path);
              setState(() {
                image = true;
              });
            }
          } else {
            dynamic _pickedFile = await picker.getImage(
                source: ImageSource.camera,
// <- Reduce Image quality
                maxHeight: 500, // <- reduce the image size
                maxWidth: 500);

            if (_pickedFile != null) {
              _image = File(_pickedFile.path);
              setState(() {
                image = true;
              });
            }
          }

//
        },
      ),
      appBar: AppBar(
        title: Text('Create Data Example'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (_futureAlbum == null)
            ? SingleChildScrollView(child: buildColumn(context))
            : buildFutureBuilder(),
      ),
    );
  }

  Column buildColumn(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: image ? Image.file(_image!) : Text('No image selected.'),
          ),
        ),
        TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'nombre'),
        ),
        Divider(),
        Divider(),
        RoundedLoadingButton(
          child: Text('crear', style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: () async {
            if (image) {
              await _upload(_image, _controller.text);
              _btnController.success();
              Navigator.pushNamed(context, 'all');
            } else {
              await _upload(_image, _controller.text);
              _btnController.success();
              Navigator.pushNamed(context, 'all');
            }
            setState(() {
              // _futureAlbum = createAlbum(_controller.text);
            });
          },
        )
        // ElevatedButton(
        //   onPressed: () async {
        //     if (image) {
        //       await _upload(_image, _controller.text);
        //       Navigator.pushNamed(context, "all");
        //     } else {
        //       await _upload1(_controller.text);
        //       Navigator.pushNamed(context, "all");
        //     }
        //     setState(() {
        //       // _futureAlbum = createAlbum(_controller.text);
        //     });
        //   },
        //   child: Text('crear'),
        // ),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }

  void _doSomething() async {
    _btnController.success();
  }
}
