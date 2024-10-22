// lib/services/role_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/roles.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RoleService {
  final String apiUrl = dotenv.env['API_URL']!;


  // Obtener la lista de roles
  Future<List<Role>> getRoles() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }


    final response = await http.get(Uri.parse('$apiUrl/roles'),
    headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
    );

    if (response.statusCode == 200) {
      final List rolesJson = json.decode(response.body);
      return rolesJson.map((json) => Role.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado, verifica tus credenciales');
    }else{
      throw Exception('Error al obtener roles. Código: ${response.statusCode}');
    }
  }

  // Crear un nuevo rol
  Future<void> createRole(String nombreRol) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/roles'),
      headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
      body: jsonEncode({
        'nombreRol': nombreRol
        }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al crear el rol. código:${response.statusCode}');
    }
  }

  // Actualizar un rol existente
  Future<void> updateRole(int idrol, String nombreRol) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/roles/$idrol'),

      headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
      body: jsonEncode({
        'nombreRol': nombreRol
        }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el rol.  Código:${response.statusCode}');
    }
  }

  // Obtener un rol por ID
  Future<Role> getRoleById(int idrol) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }

    final response = await http.get(Uri.parse('$apiUrl/roles/$idrol'),

    headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },

    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Role.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Verifica tus credenciales.');
    } else{
      throw Exception('Error al obtener el rol. Código:${response.statusCode}');
    }
  }

  // Eliminar un rol por ID
  Future<void> deleteRole(int idrol) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); //recupera token almacenado

    //verifica que no sea nulo el token

    if (token == null){
      throw Exception('No se encontro el token, inicia sesión nuevamente');
    }

    final response = await http.delete(Uri.parse('$apiUrl/roles/$idrol'),
    headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el rol.  Código:${response.statusCode}');
    }
  }
}
