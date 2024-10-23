import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/categoria.dart';
import 'package:memesv2/services/categoria_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class CategoriaList extends StatefulWidget {
  const CategoriaList({super.key});

  @override
  State<CategoriaList> createState() => _CategoriaListState();
}

class _CategoriaListState extends State<CategoriaList> {
  final CategoriaService _categoriaService = CategoriaService();
  late Future<List<Categoria>> _futureCategorias;

  @override
  void initState() {
    super.initState();
    _futureCategorias = _categoriaService.getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Categorías'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: FutureBuilder<List<Categoria>>(
        future: _futureCategorias,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categorias = snapshot.data!;

            print(categorias);

            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return ListTile(
                  title: Text(categoria.nombreCategoria),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          print('Edit button pressed for category ID: ${categoria.idCategoria}');
                          context.go('/categorias/edit/${categoria.idCategoria}');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar Categoría'),
                                content: const Text('¿Estás seguro de que deseas eliminar esta categoría?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await _categoriaService.deleteCategoria(categoria.idCategoria);
                                        setState(() {
                                          _futureCategorias = _categoriaService.getCategorias();
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Categoría eliminada con éxito')),
                                        );
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error al eliminar la categoría: $e')),
                                        );
                                      }
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/categorias/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
