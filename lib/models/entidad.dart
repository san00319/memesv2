class Entidad {
  final int identidad;
  final String nombreEntidad;
  final String nit;
  final String sector;

  Entidad({
    required this.identidad,
    required this.nombreEntidad,
    required this.nit,
    required this.sector,
  });

  // Método para convertir JSON en una instancia de Entidad
  factory Entidad.fromJson(Map<String, dynamic> json) {
    return Entidad(
      identidad: json['identidad'], // Asegúrate de que esto sea un valor válido
      nombreEntidad: json['nombreEntidad'] ?? 'Nombre no disponible', // Corrige el nombre de la clave
      nit: json['nit'] ?? 'NIT no disponible',
      sector: json['sector'] ?? 'Sector no disponible',
    );
  }

  // Método para convertir una instancia de Entidad en JSON
  Map<String, dynamic> toJson() {
    return {
      'identidad': identidad,
      'nombreEntidad': nombreEntidad, // Corrige el nombre de la clave
      'nit': nit,
      'sector': sector,
    };
  }
}
