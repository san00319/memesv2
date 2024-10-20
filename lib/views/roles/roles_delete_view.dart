import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/roles_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para eliminar un rol existente.
/// Permite al usuario confirmar la eliminación del rol seleccionado.
class RoleDelete extends StatelessWidget {
  final String idrol; // ID del rol a eliminar.

  const RoleDelete({Key? key, required this.idrol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RoleService _roleService = RoleService();

    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Rol')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Estás seguro de que deseas eliminar este rol?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Llamamos al método del servicio para eliminar el rol
                  await _roleService.deleteRole(int.parse(idrol));

                  // Mostramos un mensaje de éxito.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rol eliminado con éxito')),
                  );

                  // Regresamos a la lista de roles.
                  context.go('/roles');
                } catch (e) {
                  // En caso de error al eliminar, mostramos un mensaje.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar el rol: $e')),
                  );
                }
              },
              child: const Text('Eliminar Rol'),
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
