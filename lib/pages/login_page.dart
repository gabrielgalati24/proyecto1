import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile/animation/FadeAnimation.dart';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/services/api.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Respuesta {
  bool? ok;
  String? id;
  String? msg;
  String? token;

  Respuesta({this.msg, this.ok, this.token, this.id});

  factory Respuesta.fromJson(Map<String, dynamic> parsedJson) {
    return Respuesta(
        ok: parsedJson['ok'] ?? false,
        id: parsedJson['id'] ?? '',
        msg: parsedJson['nombre'] ?? '',
        token: parsedJson['token'] ?? '');
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                      Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),
                      // Positioned(
                      //     right: 40,
                      //     top: 40,
                      //     width: 80,
                      //     height: 150,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //           image: DecorationImage(
                      //               image:
                      //                   AssetImage('assets/images/clock.png'))),
                      //     )),
                      Positioned(
                          child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            _Form()
                            // Container(
                            //   padding: EdgeInsets.all(8.0),
                            //   decoration: BoxDecoration(
                            //       border: Border(
                            //           bottom: BorderSide(color: Colors.grey))),
                            //   child: TextField(
                            //     decoration: InputDecoration(
                            //         border: InputBorder.none,
                            //         hintText: "Email or Phone number",
                            //         hintStyle:
                            //             TextStyle(color: Colors.grey[400])),
                            //   ),
                            // ),
                            // Container(
                            //   padding: EdgeInsets.all(8.0),
                            //   child: TextField(
                            //     decoration: InputDecoration(
                            //         border: InputBorder.none,
                            //         hintText: "Password",
                            //         hintStyle:
                            //             TextStyle(color: Colors.grey[400])),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // Container(
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       gradient: LinearGradient(colors: [
                      //         Color.fromRGBO(143, 148, 251, 1),
                      //         Color.fromRGBO(143, 148, 251, .6),
                      //       ])),
                      //   child: Center(child: MaterialButton(
                      //     onPressed: () {
                      //       // Navigator.pushReplacementNamed(
                      //       //     context, "qr_reader");
                      //     },
                      //   )),
                      // ),
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        "Forgot Password?",
                        style:
                            TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  IconData? icon;
  String? placeholder;
  TextEditingController? textController;
  TextEditingController? textControllerpassword;
  final myController = TextEditingController();
  final myControllerpassword = TextEditingController();
  TextInputType? keyboardType;
  bool? isPassword;
  final LocalStorage storage = new LocalStorage('todo_app');
  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          // Image.network('https://banckedqr.herokuapp.com/uploads/users'),
          Text("nombre"),
          Container(
            padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: Offset(0, 5),
                      blurRadius: 5)
                ]),
            child: TextField(
              controller: myController,
              autocorrect: false,
              keyboardType: this.keyboardType,
              decoration: InputDecoration(
                  prefixIcon: Icon(this.icon),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: this.placeholder),
            ),
          ),
          Text("contraseña"),
          Container(
            padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: Offset(0, 5),
                      blurRadius: 5)
                ]),
            child: TextField(
              controller: myControllerpassword,
              autocorrect: false,
              keyboardType: this.keyboardType,
              decoration: InputDecoration(
                  prefixIcon: Icon(this.icon),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: this.placeholder),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(143, 148, 251, 1),
                  Color.fromRGBO(143, 148, 251, .6),
                ])),
            child: Center(
                child: MaterialButton(
              child: Text("login"),
              onPressed: () async {
                // Navigator.pushReplacementNamed(context, "all");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Response response;
                var dio = Dio();
                print(myController.text);
                // if (await storage.ready) {
                //   dynamic df = storage.setItem("token", " sdsdsdsd");
                //   print(df);
                // }

                print("hola");
                try {
                  dynamic response = await dio
                      .post('${urlApi}/api/usuarios/login', data: {
                    'email': myController.text,
                    'password': myControllerpassword.text
                  });
                  print("hola");
                  // print(response.ok);
                  // print("------- ${response.data.msg}");
                  final jsonResponse = json.decode(response.toString());
                  Respuesta res = new Respuesta.fromJson(jsonResponse);
                  print(res.id);
                  if (res.ok != null && res.ok == true) {
                    await prefs.setString('token', res.token!);
                    print(response.data.toString());
                    var x = response.data.toString();
                    //  var xx = x['_id'];
                    var y = res.id.toString();
                    print("**************** $y");
                    await prefs.setString('id', y);
                    // storage.setItem("token", res.token);
                    // var xx = storage.getItem('token');
                    // print('navergar $xx');

                    Navigator.pushReplacementNamed(context, "all");
                  } else {
                    storage.setItem("token", false);
                  }
                } catch (e) {
                  print(e);
                }
              },
            )),
          ),
          Divider()
        ],
      ),
    );
  }
}

// class CustomInput extends StatelessWidget {
//   final IconData? icon;
//   final String? placeholder;
//   final TextEditingController? textController;
//   final TextInputType? keyboardType;
//   final bool isPassword;

//   const CustomInput(
//       {Key? key,
//       @required this.icon,
//       @required this.placeholder,
//       @required this.textController,
//       this.keyboardType = TextInputType.text,
//       this.isPassword = false})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
//       margin: EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 offset: Offset(0, 5),
//                 blurRadius: 5)
//           ]),
//       child: TextField(
//         controller: this.textController,
//         autocorrect: false,
//         keyboardType: this.keyboardType,
//         obscureText: this.isPassword,
//         decoration: InputDecoration(
//             prefixIcon: Icon(this.icon),
//             focusedBorder: InputBorder.none,
//             border: InputBorder.none,
//             hintText: this.placeholder),
//       ),
//     );
//   }
// }
