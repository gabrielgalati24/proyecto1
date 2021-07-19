// import 'package:http/http.dart' as http;
// import 'package:mobile_flutter/global/environment.dart';
// import 'package:mobile_flutter/models/usuario.dart';
// import 'package:mobile_flutter/models/usuarios_response.dart';
// import 'package:mobile_flutter/services/auth_service.dart';

// class UsuariosService {
//   Future<List<Usuario>> getUsuarios() async {
//     try {
//       final resp = await http.get('${Environment.apiUrl}/usuarios', headers: {
//         'Content-Type': 'application/json',
//         'x-token': await AuthService.getToken()
//       });

//       final usuariosResponse = usuariosResponseFromJson(resp.body);

//       return usuariosResponse.usuarios;
//     } catch (e) {
//       return [];
//     }
//   }
// }
