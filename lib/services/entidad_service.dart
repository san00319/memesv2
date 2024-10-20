import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/entidad.dart';

class EntidadService {
  final String apiUrl = dotenv.env['API_URL']!;

  // Obtener la lista de entidades
  Future<List<Entidad>> getEntidades() async {
    print('Fetching entidades from: $apiUrl/entidades');

    final response = await http.get(Uri.parse('$apiUrl/entidades'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List entidadesJson = json.decode(response.body);
      return entidadesJson.map((json) => Entidad.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener entidades');
    }
  }

  // Crear una nueva entidad
  Future<void> createEntidad(String nombreEntidad, String nit, String sector) async {
    final response = await http.post(
      Uri.parse('$apiUrl/entidades'),
      body: jsonEncode({
        'nombreEntidad': nombreEntidad,
        'nit': nit,
        'sector': sector,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status: ${response.statusCode}'); // Para depurar
    print('Response body: ${response.body}'); // Para depurar

    if (response.statusCode == 201 || response.statusCode == 200) {
    // Éxito, manejar el retorno aquí
  } else {
    throw Exception('Error al crear la entidad');
  }
  }

  // Actualizar una entidad existente
  Future<void> updateEntidad(int identidad, String nombreEntidad, String nit, String sector) async {
    final response = await http.put(
      Uri.parse('$apiUrl/entidades/$identidad'),
      body: jsonEncode({
        'nombreEntidad': nombreEntidad,
        'nit': nit,
        'sector': sector,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la entidad');
    }
  }

  // Obtener una entidad por ID
  Future<Entidad> getEntidadById(int identidad) async {
    final response = await http.get(Uri.parse('$apiUrl/entidades/$identidad'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Entidad.fromJson(data);
    } else {
      throw Exception('Error al obtener la entidad');
    }
  }

  // Eliminar una entidad por ID
  Future<void> deleteEntidad(int identidad) async {
    final response = await http.delete(Uri.parse('$apiUrl/entidades/$identidad'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la entidad');
    }
  }
}
