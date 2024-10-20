import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/entidad.dart';
import 'package:memesv2/services/entidad_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class EntidadList extends StatefulWidget {
  const EntidadList({super.key});

  @override
  State<EntidadList> createState() => _EntidadListState();
}

class _EntidadListState extends State<EntidadList> {
  final EntidadService _entidadService = EntidadService();
  late Future<List<Entidad>> _futureEntidades;

  @override
  void initState() {
    super.initState();
    _futureEntidades = _entidadService.getEntidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Entidades'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: FutureBuilder<List<Entidad>>(
        future: _futureEntidades,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final entidades = snapshot.data!;

            print(entidades);

            return ListView.builder(
              itemCount: entidades.length,
              itemBuilder: (context, index) {
                final entidad = entidades[index];
                return ListTile(
                  title: Text(entidad.nombreEntidad),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          print('Edit button pressed for entidad ID: ${entidad.identidad}');
                          context.go('/entidades/edit/${entidad.identidad}');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar Entidad'),
                                content: const Text('¿Estás seguro de que deseas eliminar esta entidad?'),
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
                                        await _entidadService.deleteEntidad(entidad.identidad);
                                        setState(() {
                                          _futureEntidades = _entidadService.getEntidades();
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Entidad eliminada con éxito')),
                                        );
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error al eliminar la entidad: $e')),
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
          context.go('/entidades/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
