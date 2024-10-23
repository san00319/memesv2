// lib/services/ubicacion_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/ubicacion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbicacionService {
  final String apiUrl = dotenv.env['API_URL']!;

  // Obtener la lista de ubicaciones
  Future<List<Ubicacion>> getUbicaciones() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera el token almacenado

    // Verifica que no sea nulo el token
    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/ubicaciones'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Enviar el token en el encabezado
      },
    );

    if (response.statusCode == 200) {
      final List ubicacionesJson = json.decode(response.body);
      return ubicacionesJson.map((json) => Ubicacion.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado, verifica tus credenciales');
    } else {
      throw Exception('Error al obtener ubicaciones. Código: ${response.statusCode}');
    }
  }

  // Crear una nueva ubicación
  Future<void> createUbicacion(String nombreUbicacion, String bloque) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera el token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/ubicaciones'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Enviar el token en el encabezado
      },
      body: jsonEncode({
        'nombreUbicacion': nombreUbicacion,
        'bloque': bloque,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al crear la ubicación. Código: ${response.statusCode}');
    }
  }

  // Actualizar una ubicación existente
  Future<void> updateUbicacion(int idubicacion, String nombreUbicacion, String bloque) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera el token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/ubicaciones/$idubicacion'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Enviar el token en el encabezado
      },
      body: jsonEncode({
        'nombreUbicacion': nombreUbicacion,
        'bloque': bloque,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la ubicación. Código: ${response.statusCode}');
    }
  }

  // Obtener una ubicación por ID
  Future<Ubicacion> getUbicacionById(int idubicacion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera el token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/ubicaciones/$idubicacion'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Enviar el token en el encabezado
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Ubicacion.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Verifica tus credenciales.');
    } else {
      throw Exception('Error al obtener la ubicación. Código: ${response.statusCode}');
    }
  }

  // Eliminar una ubicación por ID
  Future<void> deleteUbicacion(int idubicacion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera el token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.delete(
      Uri.parse('$apiUrl/ubicaciones/$idubicacion'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Enviar el token en el encabezado
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la ubicación. Código: ${response.statusCode}');
    }
  }
}
