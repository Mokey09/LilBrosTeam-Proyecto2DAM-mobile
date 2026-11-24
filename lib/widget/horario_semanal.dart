import 'package:flutter/material.dart';
import 'package:synkra_app/models/sesion_horario.dart';

class HorarioSemanal extends StatelessWidget {
  const HorarioSemanal({super.key, required this.sesiones});

  final List<SesionHorario> sesiones;

  static const _dias = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (sesiones.isEmpty) {
      return Text('Sin sesiones asignadas', style: textTheme.bodyLarge);
    }

    // Agrupa por día y ordena por hora ("08:30" ordena bien como texto)
    final porDia = <int, List<SesionHorario>>{};
    for (final s in sesiones) {
      porDia.putIfAbsent(s.diaSemana, () => []).add(s);
    }
    for (final lista in porDia.values) {
      lista.sort((a, b) => a.horaInicio.compareTo(b.horaInicio));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final dia in _dias.entries)
          if (porDia[dia.key]?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dia.value,
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in porDia[dia.key]!)
                        Chip(
                          label: Text('${s.horaInicio} · ${s.codGrupo}'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
      ],
    );
  }
}