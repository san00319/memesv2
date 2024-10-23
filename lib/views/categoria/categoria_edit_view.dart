// lib/views/categorias/categoria_edit_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/categoria.dart';
import 'package:memesv2/services/categoria_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para editar una categoría existente.
/// Permite al usuario modificar el nombre y la descripción de la categoría seleccionada.

class CategoriaEdit extends StatefulWidget {
  final String idcategoria; // ID de la categoría a editar.

  const CategoriaEdit({super.key, required this.idcategoria});

  @override
  State<CategoriaEdit> createState() => _CategoriaEditState();
}

class _CategoriaEditState extends State<CategoriaEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreCategoriaController = TextEditingController();
  final TextEditingController _descripcionCategoriaController = TextEditingController();
  final CategoriaService _categoriaService = CategoriaService();
  late Future<Categoria> 
    _futureCategoria; // Futuro que contendrá la categoría a editar

  @override
  void initState() {
    super.initState();
    print('Editing category with ID: ${widget.idcategoria}');
    // Al iniciar, obtenemos los datos de la categoría por su ID
    _futureCategoria = _categoriaService.getCategoriaById(int.parse(widget.idcategoria));
  }

  @override
  void dispose() {
    _nombreCategoriaController.dispose();
    _descripcionCategoriaController.dispose();
    super.dispose();
  }

  /// Método para manejar la acción de actualizar la categoría.
  /// Valida el formulario y envía los datos actualizados al servicio.
  void _updateCategoria() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para actualizar la categoría
        await _categoriaService.updateCategoria(
          int.parse(widget.idcategoria),
          _nombreCategoriaController.text,
          _descripcionCategoriaController.text,
        );

        // Mostramos un mensaje de éxito.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría actualizada con éxito')),
        );
        context.go('/categorias'); // Regresar a la lista de categorías
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la categoría: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Categoría')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<Categoria>(
        future: _futureCategoria,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categoria = snapshot.data!;
            // Asignamos los valores actuales de la categoría a los controladores.
            _nombreCategoriaController.text = categoria.nombreCategoria;
            _descripcionCategoriaController.text = categoria.descripcionCategoria;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              // Formulario para editar los datos de la categoría.
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de texto para el nombre de la categoría.
                    TextFormField(
                      controller: _nombreCategoriaController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la Categoría',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el nombre de la categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Campo de texto para la descripción de la categoría.
                    TextFormField(
                      controller: _descripcionCategoriaController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción de la Categoría',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa la descripción de la categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón para enviar el formulario y actualizar la categoría
                    ElevatedButton(
                      onPressed: _updateCategoria,
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // En caso de error al obtener los datos, mostramos un mensaje
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Mientras se cargan los datos, mostramos un indicador de progreso.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
