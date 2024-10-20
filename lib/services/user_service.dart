import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:memesv2/views/login/loginDTO.dart';

class UserService {
  final String apiUrl = dotenv.env['API_URL']!;



  // Obtener la lista de usuarios
  Future<List<User>> getUsers() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }

    final response = await http.get(Uri.parse('$apiUrl/usuarios'),
    headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
    );

    if (response.statusCode == 200) {
      final List usersJson = json.decode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else if(response.statusCode == 401) {
      throw Exception('No autorizado, verifica tus credenciales');
    }else{
      throw Exception('Error al obtener usuarios. Código: ${response.statusCode}');
    }
  }

  /*// Método para realizar el login
  Future<String?> login(String email, String password) async {
    final loginDTO = LoginDTO(correoInstitucional: email, password: password);

    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginDTO.toJson()),
    );

    if (response.statusCode == 202) {
      // La respuesta incluye el JWT
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return responseBody['jwt']; // Devuelve el token JWT si es exitoso
    } else if (response.statusCode == 401) {
      // Si las credenciales son incorrectas
      return null;
    } else {
      throw Exception('Error en el login: ${response.statusCode}');
}
}*/

  // Crear un nuevo usuario
  Future<void> createUser(String nombreUsuario, String correoInstitucional, String telefono, String password, int identidad, int idrol) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/usuarios'),
      headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
      body: jsonEncode({
        'nombreUsuario': nombreUsuario,
        'correoInstitucional': correoInstitucional,
        'telefono': telefono,
        'contrasenna': password,
        'entidad': {'identidad': identidad}, // Asegúrate de que este campo coincida con tu backend
        'rol': {'idrol': idrol} // Asegúrate de que este campo coincida con tu backend
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al crear el usuario. Código:${response.statusCode}');
    }
  }

  // Actualizar un usuario existente
  Future<void> updateUser(int idusuario, String nombreUsuario, String correoInstitucional, String telefono) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/usuarios/$idusuario'),
      headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },

      body: jsonEncode({
        'nombreUsuario': nombreUsuario,
        'correoInstitucional': correoInstitucional,
        'telefono': telefono,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el usuario. Código:${response.statusCode}');
    }
  }

  // Obtener un usuario por su ID
  Future<User> getUserById(int idusuario) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }  

    final response = await http.get(Uri.parse('$apiUrl/usuarios/$idusuario'),
    headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Verifica tus credenciales.');
    } else{
      throw Exception('Error al obtener el usuario. Código:${response.statusCode}');
    }
  }

  // Eliminar un usuario por ID
  Future<void> deleteUser(int idusuario) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }

    final response = await http.delete(Uri.parse('$apiUrl/usuarios/$idusuario'),
    headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el usuario. Código:${response.statusCode}');
    }
  }
}
