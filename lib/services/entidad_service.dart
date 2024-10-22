import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/entidad.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntidadService {
  final String apiUrl = dotenv.env['API_URL']!;

  // Obtener la lista de entidades
  Future<List<Entidad>> getEntidades() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recuperar el token almacenado

    // Verificar que el token no sea nulo
    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/entidades'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Enviar el token en el encabezado
      },
    );

    if (response.statusCode == 200) {
      final List entidadesJson = json.decode(response.body);
      return entidadesJson.map((json) => Entidad.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado, verifica tus credenciales');
    } else {
      throw Exception('Error al obtener entidades. Código: ${response.statusCode}');
    }
  }

  // Crear una nueva entidad
  Future<void> createEntidad(String nombreEntidad, String nit, String sector) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recuperar el token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/entidades'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nombreEntidad': nombreEntidad,
        'nit': nit,
        'sector': sector,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear la entidad. Código: ${response.statusCode}');
    }
  }

  // Actualizar una entidad existente
  Future<void> updateEntidad(int identidad, String nombreEntidad, String nit, String sector) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recuperar el token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/entidades/$identidad'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nombreEntidad': nombreEntidad,
        'nit': nit,
        'sector': sector,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la entidad. Código: ${response.statusCode}');
    }
  }

  // Obtener una entidad por ID
  Future<Entidad> getEntidadById(int identidad) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recuperar el token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/entidades/$identidad'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Entidad.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado, verifica tus credenciales');
    } else {
      throw Exception('Error al obtener la entidad. Código: ${response.statusCode}');
    }
  }

  // Eliminar una entidad por ID
  Future<void> deleteEntidad(int identidad) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recuperar el token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.delete(
      Uri.parse('$apiUrl/entidades/$identidad'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la entidad. Código: ${response.statusCode}');
    }
  }
}
