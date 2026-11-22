/// Profesor tal y como lo devuelve la API (GET /auth/me).
/// La contraseña nunca viaja desde el servidor.
class Profesor {
  final int id;
  final String nombre;
  final String apellidos;
  final String? dni;
  final String email;
  final String? telefono;
  final String? direccion;
  final String? localidad;
  final int? codigoPostal;
  final String? cuerpo;
  final String rol;
  final String? especialidad;
  final String? departamento;

  const Profesor({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.rol,
    this.dni,
    this.telefono,
    this.direccion,
    this.localidad,
    this.codigoPostal,
    this.cuerpo,
    this.especialidad,
    this.departamento,
  });

  factory Profesor.fromJson(Map<String, dynamic> json) {
    return Profesor(
      id: json['id'] as int,
      nombre: (json['nombre'] ?? '') as String,
      apellidos: (json['apellidos'] ?? '') as String,
      dni: json['dni'] as String?,
      email: (json['email'] ?? '') as String,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      localidad: json['localidad'] as String?,
      codigoPostal: json['codigoPostal'] as int?,
      cuerpo: json['cuerpo'] as String?,
      rol: (json['rol'] ?? 'USUARIO') as String,
      especialidad: json['especialidad'] as String?,
      departamento: json['departamento'] as String?,
    );
  }

  String get nombreCompleto => '$nombre $apellidos'.trim();
}
