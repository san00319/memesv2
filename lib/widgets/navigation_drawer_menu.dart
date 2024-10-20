import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class NavigationDrawerMenu extends StatefulWidget {
  const NavigationDrawerMenu({super.key});

  @override
  NavigationDrawerMenuState createState() => NavigationDrawerMenuState();
}

class NavigationDrawerMenuState extends State<NavigationDrawerMenu> {
  String userName = 'Cargando...';
  String userRole = 'Usuario'; // Por defecto es Usuario
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Metodo para cargar el nombre del usuario y el rol desde SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'nombreUsuario';
      userRole = prefs.getString('userRole') ?? 'Usuario'; // Por defecto, Usuario
    });
  }

  Future<void> _logout() async {
  try {
    await _authService.logout();
    if (mounted) {
      context.go('/login');  // Navegar solo si el widget sigue montado
    }
  } catch (e) {
    print("Error al cerrar sesión: $e");
  }
}

  /// Metodo que retorna las opciones de menu para todos los roles
  List<Widget> getMenuOptions() {
    return [
      ListTile(
        leading: const Icon(Icons.category, color: Colors.black),
        title: const Text('Categorías', style: TextStyle(color: Colors.black)),
        onTap: () {
          context.go('/');
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: const Icon(Icons.mood, color: Colors.black),
        title: const Text('Memes', style: TextStyle(color: Colors.black)),
        onTap: () {
          context.go('/memes');
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: const Icon(Icons.security, color: Colors.black),
        title: const Text('Roles', style: TextStyle(color: Colors.black)),
        onTap: () {
          context.go('/roles');
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: const Icon(Icons.security, color: Colors.black),
        title: const Text('Entidades', style: TextStyle(color: Colors.black)),
        onTap: () {
          context.go('/entidades');
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: const Icon(Icons.person, color: Colors.black),
        title: const Text('Usuarios', style: TextStyle(color: Colors.black)),
        onTap: () {
          context.go('/usuarios');
          Navigator.of(context).pop();
        },
      ),
      // Puedes agregar más opciones aquí
      ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
        onTap: _logout,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido, $userName',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rol: $userRole',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          ...getMenuOptions(), // Cargar el menú
        ],
      ),
    );
  }
}
