import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/categoria_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para eliminar una categoría existente.
/// Permite al usuario confirmar la eliminación de la categoría seleccionada.
class CategoriaDelete extends StatelessWidget {
  final String idcategoria; // ID de la categoría a eliminar.

  const CategoriaDelete({Key? key, required this.idcategoria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoriaService _categoriaService = CategoriaService();

    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Categoría')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Estás seguro de que deseas eliminar esta categoría?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Llamamos al método del servicio para eliminar la categoría
                  await _categoriaService.deleteCategoria(int.parse(idcategoria));

                  // Mostramos un mensaje de éxito.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Categoría eliminada con éxito')),
                  );

                  // Regresamos a la lista de categorías.
                  context.go('/categorias');
                } catch (e) {
                  // En caso de error al eliminar, mostramos un mensaje.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la categoría: $e')),
                  );
                }
              },
              child: const Text('Eliminar Categoría'),
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
