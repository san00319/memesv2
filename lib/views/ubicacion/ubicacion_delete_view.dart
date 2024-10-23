import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/ubicacion_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para eliminar una ubicación existente.
/// Permite al usuario confirmar la eliminación de la ubicación seleccionada.
class UbicacionDelete extends StatelessWidget {
  final String idubicacion; // ID de la ubicación a eliminar.

  const UbicacionDelete({Key? key, required this.idubicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UbicacionService _ubicacionService = UbicacionService();

    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Ubicación')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Estás seguro de que deseas eliminar esta ubicación?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Llamamos al método del servicio para eliminar la ubicación
                  await _ubicacionService.deleteUbicacion(int.parse(idubicacion));

                  // Mostramos un mensaje de éxito.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ubicación eliminada con éxito')),
                  );

                  // Regresamos a la lista de ubicaciones.
                  context.go('/ubicaciones');
                } catch (e) {
                  // En caso de error al eliminar, mostramos un mensaje.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la ubicación: $e')),
                  );
                }
              },
              child: const Text('Eliminar Ubicación'),
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
