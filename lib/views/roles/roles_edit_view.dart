// lib/views/roles/role_edit_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/roles.dart';
import 'package:memesv2/services/roles_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

// Importamos el Drawer

/// Vista para editar un rol existente.
/// Permite al usuario modificar el nombre del rol seleccionado.

class RoleEdit extends StatefulWidget {
  final String idrol; // ID del rol a editar.

  const RoleEdit({super.key, required this.idrol});

  @override
  State<RoleEdit> createState() => _RoleEditState();
}

class _RoleEditState extends State<RoleEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreRolController = TextEditingController();
  final RoleService _roleService = RoleService();
  late Future<Role> 
    _futureRole; // Futuro que contendrá el rol a editar

  @override
  void initState() {
    super.initState();
    print('Editing role with ID: ${widget.idrol}');
    // Al iniciar, obtenemos los datos del rol por su ID
    _futureRole = _roleService.getRoleById(int.parse(widget.idrol));
  }

  @override
  void dispose() {
    _nombreRolController.dispose();
    super.dispose();
  }

/// Método para manejar la acción de actualizar el rol.
  /// Valida el formulario y envía los datos actualizados al servicio.
  void _updateRole() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para actualizar el rol
        await _roleService.updateRole(
          int.parse(widget.idrol),
          _nombreRolController.text,
        );

        // Mostramos un mensaje de éxito.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol actualizado con éxito')),
        );
        context.go('/roles'); // Regresar a la lista de roles
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el rol: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Rol')
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<Role>(
        future: _futureRole,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final role = snapshot.data!;
            // Asignamos los valores actuales del rol a los controladores.
            _nombreRolController.text = role.nombreRol;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              // Formulario para editar los datos del rol.
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de texto para el nombre del rol.
                    TextFormField(
                      controller: _nombreRolController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Rol'
                        ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el nombre del rol';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón para enviar el formulario y actualizar el rol
                    ElevatedButton(
                      onPressed: _updateRole,
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // En caso de error al obtener los datos, mostramos un mensaje
            return Center(child: Text('Error: ${snapshot.error}')
            );
          }
          // Mientras se cargan los datos, mostramos un indicador de progreso.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
