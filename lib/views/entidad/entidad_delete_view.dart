import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/entidad_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para eliminar una entidad existente.
/// Permite al usuario confirmar la eliminación de la entidad seleccionada.
class EntidadDelete extends StatelessWidget {
  final String identidad; // ID de la entidad a eliminar.

  const EntidadDelete({Key? key, required this.identidad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EntidadService _entidadService = EntidadService();

    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Entidad')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Estás seguro de que deseas eliminar esta entidad?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Llamamos al método del servicio para eliminar la entidad
                  await _entidadService.deleteEntidad(int.parse(identidad));

                  // Mostramos un mensaje de éxito.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entidad eliminada con éxito')),
                  );

                  // Regresamos a la lista de entidades.
                  context.go('/entidades');
                } catch (e) {
                  // En caso de error al eliminar, mostramos un mensaje.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la entidad: $e')),
                  );
                }
              },
              child: const Text('Eliminar Entidad'),
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
