import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/ubicacion.dart';
import 'package:memesv2/services/ubicacion_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class UbicacionList extends StatefulWidget {
  const UbicacionList({super.key});

  @override
  State<UbicacionList> createState() => _UbicacionListState();
}

class _UbicacionListState extends State<UbicacionList> {
  final UbicacionService _ubicacionService = UbicacionService();
  late Future<List<Ubicacion>> _futureUbicaciones;

  @override
  void initState() {
    super.initState();
    _futureUbicaciones = _ubicacionService.getUbicaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Ubicaciones'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: FutureBuilder<List<Ubicacion>>(
        future: _futureUbicaciones,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final ubicaciones = snapshot.data!;
            return ListView.builder(
              itemCount: ubicaciones.length,
              itemBuilder: (context, index) {
                final ubicacion = ubicaciones[index];
                return ListTile(
                  title: Text('${ubicacion.nombreUbicacion} - Bloque: ${ubicacion.bloque}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          print('Edit button pressed for ubicacion ID: ${ubicacion.idubicacion}');
                          context.go('/ubicaciones/edit/${ubicacion.idubicacion}');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar Ubicación'),
                                content: const Text('¿Estás seguro de que deseas eliminar esta ubicación?'),
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
                                        await _ubicacionService.deleteUbicacion(ubicacion.idubicacion);
                                        setState(() {
                                          _futureUbicaciones = _ubicacionService.getUbicaciones();
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Ubicación eliminada con éxito')),
                                        );
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error al eliminar la ubicación: $e')),
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
          context.go('/ubicaciones/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
