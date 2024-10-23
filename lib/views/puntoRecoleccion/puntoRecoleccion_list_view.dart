import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/puntoRecoleccion.dart'; 
import 'package:memesv2/services/puntoRecoleccion_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para listar todos los puntos de recolección.
class PuntoRecoleccionList extends StatefulWidget {
  const PuntoRecoleccionList({super.key});

  @override
  State<PuntoRecoleccionList> createState() => _PuntoRecoleccionListState();
}

class _PuntoRecoleccionListState extends State<PuntoRecoleccionList> {
  final PuntoRecoleccionService _puntoRecoleccionService = PuntoRecoleccionService();
  late Future<List<PuntoRecoleccion>> _futurePuntos;

  @override
  void initState() {
    super.initState();
    // Llamamos al servicio para obtener la lista de puntos de recolección
    _futurePuntos = _puntoRecoleccionService.getPuntosRecoleccion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Puntos de Recolección'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: FutureBuilder<List<PuntoRecoleccion>>(
        future: _futurePuntos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final puntos = snapshot.data!;
            return ListView.builder(
              itemCount: puntos.length,
              itemBuilder: (context, index) {
                final punto = puntos[index];
                return ListTile(
                  title: Text(punto.nombrePunto), // Nombre del punto de recolección
                  subtitle: Text('ID Entidad: ${punto.entidad.identidad} , ID Ubicación: ${punto.ubicacion.idubicacion}'), // Foráneas entidad y ubicación
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          print('Edit button pressed for Punto ID: ${punto.idpunto}');
                          context.go('/puntosRecoleccion/edit/${punto.idpunto}'); // Redirigimos a la vista de edición
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar Punto de Recolección'),
                                content: const Text('¿Estás seguro de que deseas eliminar este punto?'),
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
                                        await _puntoRecoleccionService.deletePuntoRecoleccion(punto.idpunto); // Método para eliminar punto
                                        setState(() {
                                          _futurePuntos = _puntoRecoleccionService.getPuntosRecoleccion(); // Refrescamos la lista
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Punto de recolección eliminado con éxito')),
                                        );
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error al eliminar el punto: $e')),
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
          context.go('/puntosRecoleccion/create'); // Ruta para crear un nuevo punto de recolección
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
