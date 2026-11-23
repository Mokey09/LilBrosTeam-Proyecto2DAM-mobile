import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:synkra_app/models/bloqueo.dart';

//https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/utils.dart?utm_source=chatgpt.com

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Agrupa los bloqueos de la API por día para alimentar a TableCalendar.
LinkedHashMap<DateTime, List<Event>> eventosDesdeBloqueos(
  List<Bloqueo> bloqueos,
) {
  final mapa = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  for (final b in bloqueos) {
    final titulo = (b.comentario == null || b.comentario!.trim().isEmpty)
        ? b.tipoLegible
        : '${b.tipoLegible}: ${b.comentario}';
    mapa.putIfAbsent(b.fecha, () => []).add(Event(titulo));
  }
  return mapa;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

// TODO borrar esto luego!!
// final kToday = DateTime.now();
// final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
// TODO dejar esto luego!!
final kToday = DateTime.now();
final kFirstDay = DateTime(2024, 1, 1);
final kLastDay = DateTime(2100, 12, 31);
