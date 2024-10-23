class Ubicacion {
  final int idubicacion;
  final String nombreUbicacion;
  final String bloque;

  // Constructor
  Ubicacion({
    required this.idubicacion,
    required this.nombreUbicacion,
    required this.bloque,
  });

  // Factory para crear un objeto Ubicacion a partir de un JSON
  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      idubicacion: json['idubicacion'],
      nombreUbicacion: json['nombreUbicacion'],
      bloque: json['bloque'],
    );
  }

  // Método para convertir un objeto Ubicacion a JSON
  Map<String, dynamic> toJson() {
    return {
      'idubicacion': idubicacion,
      'nombreUbicacion': nombreUbicacion,
      'bloque': bloque,
    };
  }
}
