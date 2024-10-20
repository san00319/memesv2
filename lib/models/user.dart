import 'package:memesv2/models/entidad.dart';
import 'package:memesv2/models/roles.dart';

class User {
  final int idusuario;
  final String nombreUsuario;
  final String correoInstitucional;
  final String telefono;
  final String password;
  final Entidad entidad; // Representa la relación con Entidad
  final Role rol; // Representa la relación con Role

  User({
    required this.idusuario,
    required this.nombreUsuario,
    required this.correoInstitucional,
    required this.telefono,
    required this.password,
    required this.entidad,
    required this.rol,
  });

  // Factory constructor para crear un objeto User desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idusuario: json['idusuario'],
      nombreUsuario: json['nombreUsuario'],
      correoInstitucional: json['correoInstitucional'],
      telefono: json['telefono'] ?? '',
      password: json['contrasenna'] ?? '',
      entidad: Entidad.fromJson(json['entidad']), // Aquí conviertes la Entidad
      rol: Role.fromJson(json['rol']), // Aquí conviertes el Role
    );
  }

  // Método para convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {
      'idusuario': idusuario,
      'nombreUsuario': nombreUsuario,
      'correoInstitucional': correoInstitucional,
      'telefono': telefono,
      'contrasenna': password,
      'entidad': entidad.toJson(),
      'rol': rol.toJson(),
    };
  }
}
