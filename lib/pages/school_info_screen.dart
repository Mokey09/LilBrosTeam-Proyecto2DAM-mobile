import 'package:flutter/material.dart';
import 'package:synkra_app/widget/nav_bar.dart';

/// Pantalla "Datos del centro": logotipo, dirección, contacto y horarios.
///
/// TODO todos los datos de esta pantalla estan metidos a mano por ahora,
/// TODO hay que pedirselos a la base de datos de nuestra API.
class SchoolInfoScreen extends StatelessWidget {
  const SchoolInfoScreen({super.key});

  // TODO nombre del centro, desde la API
  static const _nombre = 'IES Marcos Zaragoza';
  // TODO tipo de centro, desde la API
  static const _tipo = 'Instituto de Educación Secundaria y FP';
  // TODO direccion del centro, desde la API
  static const _direccion = 'Calle Ferrocarril, 22\n03570 La Vila Joiosa (Alicante)';
  // TODO telefono del centro, desde la API
  static const _telefono = '966 87 01 40';
  // TODO correo del centro, desde la API
  static const _correo = '03008915@edu.gva.es';

  // TODO los horarios del centro, desde la API
  static const _horarios = <_Horario>[
    _Horario(nombre: 'Clases', dias: 'Lun – Vie', horas: '8:00 – 14:30'),
    _Horario(nombre: 'Secretaría', dias: 'Lun – Vie', horas: '9:00 – 13:00'),
    _Horario(nombre: 'Tutorías', dias: 'Lun – Vie', horas: 'Con cita previa'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del centro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO el logotipo luego sera un NetworkImage que venga de la API
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/logo_centro.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  semanticLabel: 'Logotipo del $_nombre',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _nombre,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _tipo,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            const _InfoField(label: 'Dirección', value: _direccion),
            const SizedBox(height: 16),
            const _InfoField(label: 'Teléfono', value: _telefono),
            const SizedBox(height: 16),
            const _InfoField(label: 'Correo electrónico', value: _correo),
            const SizedBox(height: 24),
            Text('Horarios', style: textTheme.titleSmall),
            const SizedBox(height: 4),
            for (final h in _horarios) _HorarioRow(horario: h),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }
}

/// Etiqueta pequeña + valor + linea inferior, como en el diseño.
class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: textTheme.labelMedium),
        const SizedBox(height: 2),
        Text(value, style: textTheme.bodyLarge),
        const SizedBox(height: 6),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}

class _Horario {
  const _Horario({
    required this.nombre,
    required this.dias,
    required this.horas,
  });

  final String nombre;
  final String dias;
  final String horas;
}

class _HorarioRow extends StatelessWidget {
  const _HorarioRow({required this.horario});

  final _Horario horario;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  horario.nombre,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(horario.dias, style: textTheme.bodyMedium),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  horario.horas,
                  textAlign: TextAlign.end,
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
