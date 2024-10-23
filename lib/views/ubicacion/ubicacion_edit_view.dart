// lib/views/ubicaciones/ubicacion_edit_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/ubicacion.dart';
import 'package:memesv2/services/ubicacion_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para editar una ubicación existente.
/// Permite al usuario modificar los detalles de la ubicación seleccionada.

class UbicacionEdit extends StatefulWidget {
  final String idubicacion; // ID de la ubicación a editar.

  const UbicacionEdit({super.key, required this.idubicacion});

  @override
  State<UbicacionEdit> createState() => _UbicacionEditState();
}

class _UbicacionEditState extends State<UbicacionEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreUbicacionController = TextEditingController();
  final TextEditingController _bloqueController = TextEditingController(); // Bloque Controller
  final UbicacionService _ubicacionService = UbicacionService();
  late Future<Ubicacion> _futureUbicacion; // Futuro que contendrá la ubicación a editar

  @override
  void initState() {
    super.initState();
    print('Editing location with ID: ${widget.idubicacion}');
    // Al iniciar, obtenemos los datos de la ubicación por su ID
    _futureUbicacion = _ubicacionService.getUbicacionById(int.parse(widget.idubicacion));
  }

  @override
  void dispose() {
    _nombreUbicacionController.dispose();
    _bloqueController.dispose(); // Limpiar bloque controller
    super.dispose();
  }

  /// Método para manejar la acción de actualizar la ubicación.
  /// Valida el formulario y envía los datos actualizados al servicio.
  void _updateUbicacion() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para actualizar la ubicación
        await _ubicacionService.updateUbicacion(
          int.parse(widget.idubicacion),
          _nombreUbicacionController.text,
          _bloqueController.text, 
        );

        // Mostramos un mensaje de éxito.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ubicación actualizada con éxito')),
        );
        context.go('/ubicaciones'); // Regresar a la lista de ubicaciones
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la ubicación: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Ubicación')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<Ubicacion>(
        future: _futureUbicacion,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final ubicacion = snapshot.data!;
            // Asignamos los valores actuales de la ubicación a los controladores.
            _nombreUbicacionController.text = ubicacion.nombreUbicacion;
            _bloqueController.text = ubicacion.bloque; // Asignamos el bloque actual

            return Padding(
              padding: const EdgeInsets.all(16.0),
              // Formulario para editar los datos de la ubicación.
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de texto para el nombre de la ubicación.
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
                    // Campo de texto para el bloque.
                    TextFormField(
                      controller: _bloqueController,
                      decoration: const InputDecoration(
                        labelText: 'Bloque',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el bloque';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón para enviar el formulario y actualizar la ubicación
                    ElevatedButton(
                      onPressed: _updateUbicacion,
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
