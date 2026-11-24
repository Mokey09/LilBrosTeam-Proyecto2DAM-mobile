class SesionHorario {
  const SesionHorario({
    required this.diaSemana,
    required this.horaInicio,
    required this.codGrupo,
  });

  final int diaSemana;      // 1 = lunes ... 5 = viernes
  final String horaInicio;  // "08:30"
  final String codGrupo;

  factory SesionHorario.fromJson(Map<String, dynamic> json) {
    final hora = json['horaInicio'] as String;
    return SesionHorario(
      diaSemana: json['diaSemana'] as int,
      // La API manda "08:30:00"; nos quedamos con "08:30"
      horaInicio: hora.length >= 5 ? hora.substring(0, 5) : hora,
      codGrupo: (json['codGrupo'] as String?) ?? '—',
    );
  }
}