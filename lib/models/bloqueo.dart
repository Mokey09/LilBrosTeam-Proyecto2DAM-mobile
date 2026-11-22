/// Día bloqueado del calendario (festivo, vacaciones, evaluación...).
/// GET /bloqueados devuelve una fila por día.
class Bloqueo {
  final int id;
  final DateTime fecha;
  final String tipo;
  final String? comentario;

  const Bloqueo({
    required this.id,
    required this.fecha,
    required this.tipo,
    this.comentario,
  });

  factory Bloqueo.fromJson(Map<String, dynamic> json) {
    // La API manda la fecha como "yyyy-MM-dd"
    final partes = (json['fecha'] as String).split('-');
    return Bloqueo(
      id: json['id'] as int,
      fecha: DateTime.utc(
        int.parse(partes[0]),
        int.parse(partes[1]),
        int.parse(partes[2]),
      ),
      tipo: (json['tipo'] ?? 'OTRO') as String,
      comentario: json['comentario'] as String?,
    );
  }

  /// FESTIVO_NACIONAL -> "Festivo nacional"
  String get tipoLegible {
    final t = tipo.replaceAll('_', ' ').toLowerCase();
    return t.isEmpty ? t : t[0].toUpperCase() + t.substring(1);
  }
}
