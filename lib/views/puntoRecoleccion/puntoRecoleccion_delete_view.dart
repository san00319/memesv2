import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/puntoRecoleccion_service.dart'; // Asegúrate de tener este servicio implementado
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para eliminar un punto de recolección existente.
/// Permite al usuario confirmar la eliminación del punto de recolección seleccionado.
class PuntoRecoleccionDelete extends StatelessWidget {
  final String idpunto; // ID del punto de recolección a eliminar.

  const PuntoRecoleccionDelete({Key? key, required this.idpunto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuntoRecoleccionService _puntoRecoleccionService = PuntoRecoleccionService();

    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Punto de Recolección')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Estás seguro de que deseas eliminar este punto de recolección?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Llamamos al método del servicio para eliminar el punto de recolección
                  await _puntoRecoleccionService.deletePuntoRecoleccion(int.parse(idpunto));

                  // Mostramos un mensaje de éxito.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Punto de recolección eliminado con éxito')),
                  );

                  // Regresamos a la lista de puntos de recolección.
                  context.go('/puntos_recoleccion'); // Asegúrate de tener esta ruta definida
                } catch (e) {
                  // En caso de error al eliminar, mostramos un mensaje.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar el punto de recolección: $e')),
                  );
                }
              },
              child: const Text('Eliminar Punto de Recolección'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Regresar sin eliminar
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
