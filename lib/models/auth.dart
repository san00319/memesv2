class AuthModel {
  final String token;
  //final int idusuario;
  final String nombreUsuario;
  //final String correoInstitucional;
  final String rol;

  AuthModel({
    required this.token,
    //required this.idusuario,
    required this.nombreUsuario,
    //required this.correoInstitucional,
    required this.rol,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['jwt'],
      //idusuario: json['user']['idusuario'],
      nombreUsuario: json['nombreUsuario'],
      //correoInstitucional: json['user']['correoInstitucional'],
      rol: json['rol'],
    );
  }
}
