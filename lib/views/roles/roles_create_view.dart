// lib/views/roles/role_create_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:memesv2/services/roles_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class RoleCreate extends StatefulWidget {
  const RoleCreate({super.key});

  @override
  State<RoleCreate> createState() => _RoleCreateState();
}

class _RoleCreateState extends State<RoleCreate> {
    // Clave global para el formulario, nos permite validar el formulario más adelante.
  final _formKey = GlobalKey<FormState>();

    // Controladores para los campos de texto.
  final TextEditingController _nombreRolController = TextEditingController();

    // Instancia del servicio de categoria
  final RoleService _roleService = RoleService();

  @override
  void dispose() {
    // se liberan los controladores cuando ya no son necesarios.
    _nombreRolController.dispose();
    super.dispose();
  }

// Metodo para manejar la accion de crear una nueva categoria.
  // Valida el formulario y envia los datos al servicio.
  void _createRole() async {
    if (_formKey.currentState!.validate()) {
      try {

        // Llamamos al metodo del servicio para crear el rol.

        await _roleService.createRole(
          _nombreRolController.text
          );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol creado con éxito')),
        );

        // luego de crear el registro, navega a la lista de categorías.
        // ignore: use_build_context_synchronously
        context.go('/roles'); // Regresar a la lista de roles
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el rol: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Rol')
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Formulario para ingresar los datos del rol.
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de texto para el nombre del rol
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
              // Botón para enviar el formulario y crear el rol
              ElevatedButton(
                onPressed: _createRole,
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
