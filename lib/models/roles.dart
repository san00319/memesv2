// lib/models/role.dart

class Role {
  final int idrol;
  final String nombreRol;

  Role({required this.idrol, required this.nombreRol});

  // Método para convertir JSON en una instancia de Role
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      idrol: json['idrol'],
      nombreRol: json['nombreRol'],
    );
  }

  // Método para convertir una instancia de Role a JSON
  Map<String, dynamic> toJson() {
    return {
      'idrol': idrol,
      'nombreRol': nombreRol,
    };
  }
}
