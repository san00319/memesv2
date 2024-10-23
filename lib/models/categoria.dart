class Categoria {
  final int idCategoria;
  final String nombreCategoria;
  final String descripcionCategoria;

  Categoria({
    required this.idCategoria,
    required this.nombreCategoria,
    required this.descripcionCategoria,
  });

  // Método para crear una instancia de Categoria desde un JSON
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['idCategoria']as int,
      nombreCategoria: json['nombreCategoria'],
      descripcionCategoria: json['descripcionCategoria'], // No permitimos que sea null
    );
  }

  // Método para convertir una instancia de Categoria a JSON
  Map<String, dynamic> toJson() {
    return {
      'idCategoria': idCategoria,
      'nombreCategoria': nombreCategoria,
      'descripcionCategoria': descripcionCategoria,
    };
  }
}
