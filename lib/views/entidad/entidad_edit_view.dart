// lib/views/entidades/entidad_edit_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/entidad.dart';
import 'package:memesv2/services/entidad_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para editar una entidad existente.
/// Permite al usuario modificar los detalles de la entidad seleccionada.

class EntidadEdit extends StatefulWidget {
  final String identidad; // ID de la entidad a editar.

  const EntidadEdit({super.key, required this.identidad});

  @override
  State<EntidadEdit> createState() => _EntidadEditState();
}

class _EntidadEditState extends State<EntidadEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreEntidadController = TextEditingController();
  final TextEditingController _nitController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final EntidadService _entidadService = EntidadService();
  late Future<Entidad> 
    _futureEntidad; // Futuro que contendrá la entidad a editar

  @override
  void initState() {
    super.initState();
    print('Editing entidad with ID: ${widget.identidad}');
    // Al iniciar, obtenemos los datos de la entidad por su ID
    _futureEntidad = _entidadService.getEntidadById(int.parse(widget.identidad));
  }

  @override
  void dispose() {
    _nombreEntidadController.dispose();
    _nitController.dispose();
    _sectorController.dispose();
    super.dispose();
  }

  /// Método para manejar la acción de actualizar la entidad.
  /// Valida el formulario y envía los datos actualizados al servicio.
  void _updateEntidad() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para actualizar la entidad
        await _entidadService.updateEntidad(
          int.parse(widget.identidad),
          _nombreEntidadController.text,
          _nitController.text,
          _sectorController.text,
        );

        // Mostramos un mensaje de éxito.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entidad actualizada con éxito')),
        );
        context.go('/entidades'); // Regresar a la lista de entidades
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la entidad: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Entidad')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<Entidad>(
        future: _futureEntidad,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final entidad = snapshot.data!;
            // Asignamos los valores actuales de la entidad a los controladores.
            _nombreEntidadController.text = entidad.nombreEntidad;
            _nitController.text = entidad.nit;
            _sectorController.text = entidad.sector;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              // Formulario para editar los datos de la entidad.
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de texto para el nombre de la entidad.
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
                    // Campo de texto para el NIT.
                    TextFormField(
                      controller: _nitController,
                      decoration: const InputDecoration(
                        labelText: 'Número de NIT',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el NIT';
                        }
                        return null;
                      },
                    ),
                    // Campo de texto para el sector.
                    TextFormField(
                      controller: _sectorController,
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
                    // Botón para enviar el formulario y actualizar la entidad.
                    ElevatedButton(
                      onPressed: _updateEntidad,
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
