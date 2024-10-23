import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/puntoRecoleccion.dart'; // Asegúrate de tener este modelo implementado
import 'package:memesv2/services/puntoRecoleccion_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para editar un punto de recolección existente.
/// Permite al usuario modificar los datos del punto de recolección seleccionado.
class PuntoRecoleccionEdit extends StatefulWidget {
  final String idpunto; // ID del punto de recolección a editar.

  const PuntoRecoleccionEdit({super.key, required this.idpunto});

  @override
  State<PuntoRecoleccionEdit> createState() => _PuntoRecoleccionEditState();
}

class _PuntoRecoleccionEditState extends State<PuntoRecoleccionEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombrePuntoController = TextEditingController();
  final PuntoRecoleccionService _puntoRecoleccionService = PuntoRecoleccionService();
  late Future<PuntoRecoleccion> _futurePunto; // Futuro que contendrá el punto a editar

  @override
  void initState() {
    super.initState();
    print('Editing point of collection with ID: ${widget.idpunto}');
    // Al iniciar, obtenemos los datos del punto de recolección por su ID
    _futurePunto = _puntoRecoleccionService.getPuntoRecoleccionById(int.parse(widget.idpunto));
  }

  @override
  void dispose() {
    _nombrePuntoController.dispose();
    super.dispose();
  }

  /// Método para manejar la acción de actualizar el punto de recolección.
  /// Valida el formulario y envía los datos actualizados al servicio.
  void _updatePuntoRecoleccion() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para actualizar el punto de recolección
        await _puntoRecoleccionService.updatePuntoRecoleccion(
          int.parse(widget.idpunto),
          _nombrePuntoController.text,
        );

        // Mostramos un mensaje de éxito.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Punto de recolección actualizado con éxito')),
        );
        context.go('/puntosRecoleccion'); // Regresar a la lista de puntos de recolección
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el punto de recolección: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Punto de Recolección')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<PuntoRecoleccion>(
        future: _futurePunto,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final punto = snapshot.data!;
            // Asignamos los valores actuales del punto a los controladores.
            _nombrePuntoController.text = punto.nombrePunto;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              // Formulario para editar los datos del punto de recolección.
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de texto para el nombre del punto de recolección.
                    TextFormField(
                      controller: _nombrePuntoController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Punto de Recolección',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el nombre del punto';
                        }
                        return null;
                      },
                    ),                    
                    const SizedBox(height: 20),
                    // Botón para enviar el formulario y actualizar el punto de recolección
                    ElevatedButton(
                      onPressed: _updatePuntoRecoleccion,
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
