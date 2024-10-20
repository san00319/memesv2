import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/router/app_router.dart'; // Ruta del archivo del router
import 'config/router/theme/theme.dart'; // Ruta del archivo de temas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carga las variables de entorno
  await dotenv.load(fileName: ".env");

  // Verifica el estado de inicio de sesión
  bool isLoggedIn = await checkLoginStatus();

  // Ejecuta la app, pasando el estado de autenticación
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CRUD de Categorías',
      theme: AppTheme.lightTheme, // Tema claro
      darkTheme: AppTheme.darkTheme, // Tema oscuro opcional
      themeMode: ThemeMode.system, // Tema basado en el modo del sistema
      routerConfig: AppRouter.router(isLoggedIn), // Configura el router con el estado de autenticación
    );
  }
}

// Esta función verifica si el usuario ha iniciado sesión
Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token'); // Aquí se asume que el token se guarda en SharedPreferences
  return token != null; // Si existe un token, el usuario está logueado
}
