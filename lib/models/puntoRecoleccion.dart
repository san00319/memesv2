import 'package:memesv2/models/entidad.dart';
import 'package:memesv2/models/ubicacion.dart';

class PuntoRecoleccion {
  final int idpunto;
  final String nombrePunto;
  final Entidad entidad; // Asegúrate de que este modelo también esté definido
  final Ubicacion ubicacion; // Asegúrate de que este modelo también esté definido

  PuntoRecoleccion({
    required this.idpunto,
    required this.nombrePunto,
    required this.entidad,
    required this.ubicacion,
  });

  factory PuntoRecoleccion.fromJson(Map<String, dynamic> json) {
    return PuntoRecoleccion(
      idpunto: json['idpunto'],
      nombrePunto: json['nombrePunto'],
      entidad: Entidad.fromJson(json['entidad']), // Asegúrate de implementar el método fromJson en el modelo Entidad
      ubicacion: Ubicacion.fromJson(json['ubicacion']), // Asegúrate de implementar el método fromJson en el modelo Ubicacion
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idpunto': idpunto,
      'nombrePunto': nombrePunto,
      'entidad': entidad.toJson(), // Asegúrate de implementar el método toJson en el modelo Entidad
      'ubicacion': ubicacion.toJson(), // Asegúrate de implementar el método toJson en el modelo Ubicacion
    };
  }
}
