// lib/services/role_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/roles.dart';

class RoleService {
  final String apiUrl = dotenv.env['API_URL']!;

  // Obtener la lista de roles
  Future<List<Role>> getRoles() async {
    final response = await http.get(Uri.parse('$apiUrl/roles'));
    if (response.statusCode == 200) {
      final List rolesJson = json.decode(response.body);
      return rolesJson.map((json) => Role.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener roles');
    }
  }

  // Crear un nuevo rol
  Future<void> createRole(String nombreRol) async {
    final response = await http.post(
      Uri.parse('$apiUrl/roles'),
      body: jsonEncode({'nombreRol': nombreRol}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al crear el rol');
    }
  }

  // Actualizar un rol existente
  Future<void> updateRole(int idrol, String nombreRol) async {
    final response = await http.put(
      Uri.parse('$apiUrl/roles/$idrol'),
      body: jsonEncode({'nombreRol': nombreRol}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el rol');
    }
  }

  // Obtener un rol por ID
  Future<Role> getRoleById(int idrol) async {
    final response = await http.get(Uri.parse('$apiUrl/roles/$idrol'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Role.fromJson(data);
    } else {
      throw Exception('Error al obtener el rol');
    }
  }

  // Eliminar un rol por ID
  Future<void> deleteRole(int idrol) async {
    final response = await http.delete(Uri.parse('$apiUrl/roles/$idrol'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el rol');
    }
  }
}
