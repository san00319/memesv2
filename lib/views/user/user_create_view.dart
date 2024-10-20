import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/user_service.dart';
import 'package:memesv2/services/roles_service.dart';
import 'package:memesv2/services/entidad_service.dart';
import 'package:memesv2/models/roles.dart';
import 'package:memesv2/models/entidad.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class UserCreate extends StatefulWidget {
  const UserCreate({super.key});

  @override
  State<UserCreate> createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  // Clave global para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _nombreUsuarioController = TextEditingController();
  final TextEditingController _correoInstitucionalController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instancias de los servicios
  final UserService _userService = UserService();
  final RoleService _roleService = RoleService();
  final EntidadService _entidadService = EntidadService();

  // Variables para las listas de roles y entidades
  List<Role> _roles = [];
  List<Entidad> _entidades = [];

  // Variables seleccionadas
  Role? _selectedRole;
  Entidad? _selectedEntidad;

  @override
  void initState() {
    super.initState();
    _fetchRolesAndEntidades(); // Cargar roles y entidades cuando la vista se inicie
  }

  // Método para obtener roles y entidades
  Future<void> _fetchRolesAndEntidades() async {
    try {
      final roles = await _roleService.getRoles();
      final entidades = await _entidadService.getEntidades();
      setState(() {
        _roles = roles;
        _entidades = entidades;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar roles y entidades: $e')),
      );
    }
  }

  // Método para manejar la creación del usuario
  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _userService.createUser(
          _nombreUsuarioController.text,
          _correoInstitucionalController.text,
          _telefonoController.text,
          _passwordController.text,
          _selectedEntidad!.identidad, // Verifica que haya una entidad seleccionada
          _selectedRole!.idrol // Verifica que haya un rol seleccionado
        );

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado con éxito')),
        );

        // Regresar a la lista de usuarios
        // ignore: use_build_context_synchronously
        context.go('/usuarios');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el usuario: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Liberar los controladores cuando ya no sean necesarios
    _nombreUsuarioController.dispose();
    _correoInstitucionalController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Usuario'),
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo para el nombre de usuario
              TextFormField(
                controller: _nombreUsuarioController,
                decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del usuario';
                  } else if (value.length < 3) {
                    return 'El nombre de usuario debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo para el correo institucional con validación de formato
              TextFormField(
                controller: _correoInstitucionalController,
                decoration: const InputDecoration(labelText: 'Correo Institucional'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el correo institucional';
                  }
                  // Validación de formato de correo electrónico
                  String pattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Por favor, ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo para el teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el teléfono';
                  } else if (value.length < 10) {
                    return 'El teléfono debe tener al menos 10 dígitos';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'El teléfono solo puede contener dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo para la contraseña
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una contraseña';
                  } else if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  } else if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).+$').hasMatch(value)) {
                    return 'La contraseña debe incluir al menos una mayúscula, un número y un carácter especial';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Dropdown para seleccionar una entidad
              DropdownButtonFormField<Entidad>(
                decoration: const InputDecoration(labelText: 'Entidad'),
                items: _entidades.map((entidad) {
                  return DropdownMenuItem(
                    value: entidad,
                    child: Text(entidad.nombreEntidad),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEntidad = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una entidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Dropdown para seleccionar un rol
              DropdownButtonFormField<Role>(
                decoration: const InputDecoration(labelText: 'Rol'),
                items: _roles.map((rol) {
                  return DropdownMenuItem(
                    value: rol,
                    child: Text(rol.nombreRol),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona un rol';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Botón para crear el usuario
              ElevatedButton(
                onPressed: _createUser,
                child: const Text('Crear Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
