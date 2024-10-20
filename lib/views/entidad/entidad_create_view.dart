// lib/views/entidades/entidad_create_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:memesv2/services/entidad_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class EntidadCreate extends StatefulWidget {
  const EntidadCreate({super.key});

  @override
  State<EntidadCreate> createState() => _EntidadCreateState();
}

class _EntidadCreateState extends State<EntidadCreate> {
  // Clave global para el formulario, nos permite validar el formulario más adelante.
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto.
  final TextEditingController _nombreEntidadController = TextEditingController();
  final TextEditingController _nitEntidadController = TextEditingController();
  final TextEditingController _sectorEntidadController = TextEditingController();  // Nuevo controlador para sector

  // Instancia del servicio de entidad
  final EntidadService _entidadService = EntidadService();

  @override
  void dispose() {
    // Se liberan los controladores cuando ya no son necesarios.
    _nombreEntidadController.dispose();
    _nitEntidadController.dispose();
    _sectorEntidadController.dispose();  // Liberar el controlador de sector
    super.dispose();
  }

  // Método para manejar la acción de crear una nueva entidad.
  // Valida el formulario y envía los datos al servicio.
  void _createEntidad() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para crear la entidad.
        await _entidadService.createEntidad(
          _nombreEntidadController.text,
          _nitEntidadController.text,
          _sectorEntidadController.text  // Incluir el campo sector
        );

        // Mostrar mensaje de éxito.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entidad creada con éxito')),
        );

        // Navegar a la lista de entidades.
        // ignore: use_build_context_synchronously
        context.go('/entidades'); // Regresar a la lista de entidades
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la entidad: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Entidad')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Formulario para ingresar los datos de la entidad.
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de texto para el nombre de la entidad
              TextFormField(
                controller: _nombreEntidadController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Entidad',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre de la entidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo de texto para el NIT de la entidad
              TextFormField(
                controller: _nitEntidadController,
                decoration: const InputDecoration(
                  labelText: 'NIT de la Entidad',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el NIT de la entidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo de texto para el sector de la entidad
              TextFormField(
                controller: _sectorEntidadController,
                decoration: const InputDecoration(
                  labelText: 'Sector de la Entidad',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el sector de la entidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Botón para enviar el formulario y crear la entidad
              ElevatedButton(
                onPressed: _createEntidad,
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
