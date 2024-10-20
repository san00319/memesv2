import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:memesv2/models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class AuthService {
  final String apiUrl = dotenv.env['API_URL']!;

  Future<AuthModel?> login(String correoInstitucional, String password) async {
  final url = Uri.parse('$apiUrl/auth/login');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'correoInstitucional': correoInstitucional,
      'contrasenna': password, // Cambié 'contrasenna' a 'password' para coincidir con el backend
    }),
  );

  print(url);
  print(correoInstitucional);
  print(password);

  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 202) {
    final Map<String, dynamic> data = jsonDecode(response.body);


    print('Datos de la respuesta: $data'); // Agrega esto para ver el contenido
    if (data['jwt'] != null) {
      final auth = AuthModel.fromJson(data);

      // Guardar token y datos del usuario en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', auth.token);
      await prefs.setString('userName', auth.nombreUsuario); // Guarda el nombre del usuario
      await prefs.setString('userRole', auth.rol); // Guarda el rol del usuario
      return auth;
    } else {


      print('Error: No se recibió el token');
      return null; // Login fallido, no se recibió el token
    }
  } else if (response.statusCode == 401) {
    print('Error: Credenciales incorrectas.');
    return null; // Credenciales incorrectas
  } else {
    throw Exception('Error en la autenticación: ${response.statusCode}');
  }
}


  /// Metodo para cerrar sesion
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');

    if (token != null) {
      final url = Uri.parse('$apiUrl/logout');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Limpiar los datos de sesion si el logout es exitoso
          await prefs.clear();
        } else {
          if (kDebugMode) {
            print('Error al cerrar sesion: ${data['message']}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Error al cerrar sesion: ${response.statusCode}');
        }
      }
    } else {
      if (kDebugMode) {
        print('No se encontró el token para cerrar sesion.');
      }
    }
  }

  /// Método para obtener el token guardado
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
