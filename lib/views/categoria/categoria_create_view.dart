// lib/views/categorias/categoria_create_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:memesv2/services/categoria_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class CategoriaCreate extends StatefulWidget {
  const CategoriaCreate({super.key});

  @override
  State<CategoriaCreate> createState() => _CategoriaCreateState();
}

class _CategoriaCreateState extends State<CategoriaCreate> {
  // Clave global para el formulario, nos permite validar el formulario más adelante.
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto.
  final TextEditingController _nombreCategoriaController = TextEditingController();
  final TextEditingController _descripcionCategoriaController = TextEditingController();

  // Instancia del servicio de categoría
  final CategoriaService _categoriaService = CategoriaService();

  @override
  void dispose() {
    // se liberan los controladores cuando ya no son necesarios.
    _nombreCategoriaController.dispose();
    _descripcionCategoriaController.dispose();
    super.dispose();
  }

  // Método para manejar la acción de crear una nueva categoría.
  // Valida el formulario y envía los datos al servicio.
  void _createCategoria() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para crear la categoría.
        await _categoriaService.createCategoria(
          _nombreCategoriaController.text,
          _descripcionCategoriaController.text,
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría creada con éxito')),
        );

        // luego de crear el registro, navega a la lista de categorías.
        // ignore: use_build_context_synchronously
        context.go('/categorias'); // Regresar a la lista de categorías
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la categoría: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Categoría'),
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Formulario para ingresar los datos de la categoría.
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de texto para el nombre de la categoría
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
              // Campo de texto para la descripción de la categoría
              TextFormField(
                controller: _descripcionCategoriaController,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la Categoría',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Botón para enviar el formulario y crear la categoría
              ElevatedButton(
                onPressed: _createCategoria,
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
