import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/roles.dart';
import 'package:memesv2/services/roles_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class RoleList extends StatefulWidget {
  const RoleList({super.key});

  @override
  State<RoleList> createState() => _RoleListState();
}

class _RoleListState extends State<RoleList> {
  final RoleService _roleService = RoleService();
  late Future<List<Role>> _futureRoles;

  @override
  void initState() {
    super.initState();
    _futureRoles = _roleService.getRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Roles'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: FutureBuilder<List<Role>>(
        future: _futureRoles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final roles = snapshot.data!;
            return ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                final role = roles[index];
                return ListTile(
                  title: Text(role.nombreRol),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          print('Edit button pressed for role ID: ${role.idrol}');
                          context.go('/roles/edit/${role.idrol}');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar Rol'),
                                content: const Text('¿Estás seguro de que deseas eliminar este rol?'),
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
                                        await _roleService.deleteRole(role.idrol);
                                        setState(() {
                                          _futureRoles = _roleService.getRoles();
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Rol eliminado con éxito')),
                                        );
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error al eliminar el rol: $e')),
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
          context.go('/roles/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}