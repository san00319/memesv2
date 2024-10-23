// lib/views/ubicaciones/ubicacion_create_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:memesv2/services/ubicacion_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class UbicacionCreate extends StatefulWidget {
  const UbicacionCreate({super.key});

  @override
  State<UbicacionCreate> createState() => _UbicacionCreateState();
}

class _UbicacionCreateState extends State<UbicacionCreate> {
  // Clave global para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _nombreUbicacionController = TextEditingController();
  final TextEditingController _bloqueController = TextEditingController();

  // Instancia del servicio de ubicación
  final UbicacionService _ubicacionService = UbicacionService();

  @override
  void dispose() {
    // Libera los controladores cuando ya no son necesarios
    _nombreUbicacionController.dispose();
    _bloqueController.dispose();
    super.dispose();
  }

  // Método para manejar la acción de crear una nueva ubicación
  void _createUbicacion() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para crear la ubicación
        await _ubicacionService.createUbicacion(
          _nombreUbicacionController.text,
          _bloqueController.text,
        );

        // Notificación de éxito
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ubicación creada con éxito')),
        );

        // Navegamos de vuelta a la lista de ubicaciones
        // ignore: use_build_context_synchronously
        context.go('/ubicaciones');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la ubicación: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Ubicación'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Formulario para ingresar los datos de la ubicación
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de texto para el nombre de la ubicación
              TextFormField(
                controller: _nombreUbicacionController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Ubicación',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre de la ubicación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo de texto para la dirección
              TextFormField(
                controller: _bloqueController,
                decoration: const InputDecoration(
                  labelText: 'Bloque',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el Bloque';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Botón para enviar el formulario y crear la ubicación
              ElevatedButton(
                onPressed: _createUbicacion,
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
