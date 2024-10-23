import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/categoria.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriaService {
  final String apiUrl = dotenv.env['API_URL']!;

  // Obtener la lista de categorías
  Future<List<Categoria>> getCategorias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/categorias'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
        print('Respuesta de la API: ${response.body}'); // Agregar este log

      final List categoriasJson = json.decode(response.body);
      return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado, verifica tus credenciales');
    } else {
      throw Exception('Error al obtener categorías. Código: ${response.statusCode}');
    }
  }

  // Crear una nueva categoría
  Future<void> createCategoria(String nombreCategoria, String descripcionCategoria) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/categorias'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nombreCategoria': nombreCategoria,
        'descripcionCategoria': descripcionCategoria,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al crear la categoría. Código: ${response.statusCode}');
    }
  }

  // Actualizar una categoría existente
  Future<void> updateCategoria(int idcategoria, String nombreCategoria, String descripcionCategoria) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/categorias/$idcategoria'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nombreCategoria': nombreCategoria,
        'descripcionCategoria': descripcionCategoria
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la categoría. Código: ${response.statusCode}');
    }
  }

  // Obtener una categoría por ID
  Future<Categoria> getCategoriaById(int idcategoria) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/categorias/$idcategoria'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Categoria.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado, verifica tus credenciales');
    } else {
      throw Exception('Error al obtener la categoría. Código: ${response.statusCode}');
    }
  }

  // Eliminar una categoría por ID
  Future<void> deleteCategoria(int idcategoria) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No se encontró el token, inicia sesión nuevamente');
    }

    final response = await http.delete(
      Uri.parse('$apiUrl/categorias/$idcategoria'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la categoría. Código: ${response.statusCode}');
    }
  }
}
