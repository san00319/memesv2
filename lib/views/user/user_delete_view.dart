import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/user_service.dart'; // Asegúrate de tener este servicio implementado
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para eliminar un usuario existente.
/// Permite al usuario confirmar la eliminación del usuario seleccionado.
class UserDelete extends StatelessWidget {
  final String idusuario; // ID del usuario a eliminar.

  const UserDelete({Key? key, required this.idusuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserService _userService = UserService();

    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Usuario')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Estás seguro de que deseas eliminar este usuario?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Llamamos al método del servicio para eliminar el usuario
                  await _userService.deleteUser(int.parse(idusuario));

                  // Mostramos un mensaje de éxito.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario eliminado con éxito')),
                  );

                  // Regresamos a la lista de usuarios.
                  context.go('/usuarios');
                } catch (e) {
                  // En caso de error al eliminar, mostramos un mensaje.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar el usuario: $e')),
                  );
                }
              },
              child: const Text('Eliminar Usuario'),
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
