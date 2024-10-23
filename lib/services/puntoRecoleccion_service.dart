import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/puntoRecoleccion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuntoRecoleccionService {
  final String apiUrl = dotenv.env['API_URL']!;

  // Obtener la lista de puntos de recolección
  Future<List<PuntoRecoleccion>> getPuntosRecoleccion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.get(Uri.parse('$apiUrl/puntosrecoleccion'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List puntosJson = json.decode(response.body);
      return puntosJson.map((json) => PuntoRecoleccion.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado, verifica tus credenciales');
    } else {
      throw Exception('Error al obtener puntos de recolección. Código: ${response.statusCode}');
    }
  }

  // Crear un nuevo punto de recolección
  Future<void> createPuntoRecoleccion(String nombrePunto, int entidadId, int ubicacionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/puntosrecoleccion'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nombrePunto': nombrePunto,
        'entidad': {'identidad': entidadId}, // Asegúrate de que este campo coincida con tu backend
        'ubicacion': {'idubicacion': ubicacionId}, // Asegúrate de que este campo coincida con tu backend
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al crear el punto de recolección. Código: ${response.statusCode}');
    }
  }

  // Actualizar un punto de recolección existente
  Future<void> updatePuntoRecoleccion(int idpunto, String nombrePunto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/puntosrecoleccion/$idpunto'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nombrePunto': nombrePunto,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el punto de recolección. Código: ${response.statusCode}');
    }
  }

  // Obtener un punto de recolección por su ID
  Future<PuntoRecoleccion> getPuntoRecoleccionById(int idpunto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.get(Uri.parse('$apiUrl/puntosrecoleccion/$idpunto'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PuntoRecoleccion.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Verifica tus credenciales.');
    } else {
      throw Exception('Error al obtener el punto de recolección. Código: ${response.statusCode}');
    }
  }

  // Eliminar un punto de recolección por ID
  Future<void> deletePuntoRecoleccion(int idpunto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Recupera token almacenado

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.delete(Uri.parse('$apiUrl/puntosrecoleccion/$idpunto'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el punto de recolección. Código: ${response.statusCode}');
    }
  }
}
