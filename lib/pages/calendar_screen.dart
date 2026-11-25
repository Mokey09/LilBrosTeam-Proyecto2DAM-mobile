import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:synkra_app/pages/solicitud_screen.dart';
import 'package:synkra_app/services/api_client.dart';
import 'package:synkra_app/widget/nav_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import '/utils/utils.dart';

//https://pub.dev/packages/table_calendar
//https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/pages/events_example.dart

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;

  // Eventos (días bloqueados) cargados desde la API
  LinkedHashMap<DateTime, List<Event>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  // Tipo de bloqueo de cada día (ej. "FESTIVO_NACIONAL"), para elegir el color
  LinkedHashMap<DateTime, String> _tipoPorDia = LinkedHashMap(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  bool _loading = true;
  String? _error;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final bloqueos = await ApiClient.instance.bloqueos();
      if (!mounted) return;
      // Si hay varios bloqueos el mismo día, manda el primero
      final tipos = LinkedHashMap<DateTime, String>(
        equals: isSameDay,
        hashCode: getHashCode,
      );
      for (final b in bloqueos) {
        tipos.putIfAbsent(b.fecha, () => b.tipo);
      }
      setState(() {
        _events = eventosDesdeBloqueos(bloqueos);
        _tipoPorDia = tipos;
        _loading = false;
      });
      // Refresca la lista del día seleccionado con los datos nuevos
      if (_selectedDay != null) {
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      }
    } on UnauthorizedException {
      // Token caducado: de vuelta al login
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        'login_screen',
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  // Recibe Bloqueo.tipo tal cual llega de la API (ej. "FESTIVO_NACIONAL")
  Color _colorBasedType(String? tipo) {
    switch (tipo?.toUpperCase()) {
      case "FESTIVO_NACIONAL":
      case "FESTIVO_AUTONOMICO":
      case "FESTIVO_LOCAL":
        return Colors.amber;
      case "VACACIONES":
        return Colors.green;
      case "DIA_NO_LECTIVO":
        return Colors.red;
      case "EVALUACION":
      case "PERIODO_EXAMENES":
        return Colors.deepPurple;
      case "OTRO":
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  Color _colorForDay(DateTime day) => _colorBasedType(_tipoPorDia[day]);

  // ---------------------------------------------------------------------------
  // Barras continuas para días bloqueados consecutivos
  // ---------------------------------------------------------------------------

  bool _hasEvents(DateTime day) => _getEventsForDay(day).isNotEmpty;

  // Días naturales contiguos (los fines de semana también cuentan)
  DateTime _prevDay(DateTime day) => day.subtract(const Duration(days: 1));
  DateTime _nextDay(DateTime day) => day.add(const Duration(days: 1));

  // Devuelve null si el día no está bloqueado (así table_calendar usa su
  // aspecto por defecto). Si está bloqueado, dibuja la "píldora" y la une con
  // los vecinos bloqueados.
  // Con outsideDaysVisible: true los días de otros meses siempre se ven,
  // así que el vecino cuenta aunque sea del mes anterior/siguiente.
  // Solo se une con vecinos bloqueados del mismo color (mismo tipo o tipos
  // que comparten color, como los tres festivos).
  bool _neighborBlocked(DateTime day, DateTime neighbor) {
    return _hasEvents(neighbor) && _colorForDay(neighbor) == _colorForDay(day);
  }

  Widget? _buildBlockedDay(
    DateTime day, {
    bool selected = false,
    bool outside = false,
  }) {
    if (!_hasEvents(day)) return null;

    final prev = _neighborBlocked(day, _prevDay(day));
    final next = _neighborBlocked(day, _nextDay(day));

    // Lunes (inicio de fila) y domingo (final de fila): la barra se corta ahí
    // porque el vecino queda en otra fila.
    final joinLeft = prev && day.weekday != DateTime.monday;
    final joinRight = next && day.weekday != DateTime.sunday;

    const r = Radius.circular(100);

    Color color = _colorForDay(day);
    if (selected) {
      // El día seleccionado se ve más oscuro para distinguirlo dentro de la barra
      color = HSLColor.fromColor(color).withLightness(0.35).toColor();
    }
    if (outside) {
      // Días del mes anterior/siguiente: mismo color pero más suave
      color = color.withAlpha(110);
    }

    return Container(
      margin: EdgeInsets.only(
        top: 6.0,
        bottom: 6.0,
        left: joinLeft ? 0 : 6.0,
        right: joinRight ? 0 : 6.0,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.horizontal(
          left: joinLeft ? Radius.zero : r,
          right: joinRight ? Radius.zero : r,
        ),
      ),
      child: Text(
        '${day.day}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Leyenda de colores
  // ---------------------------------------------------------------------------

  // Un tipo representativo por color, para no repetir los tres festivos y
  // reutilizar _colorBasedType (así la leyenda siempre coincide con el calendario)
  static const List<({String tipo, String etiqueta})> _leyenda = [
    (tipo: 'FESTIVO_NACIONAL', etiqueta: 'Festivo'),
    (tipo: 'VACACIONES', etiqueta: 'Vacaciones'),
    (tipo: 'DIA_NO_LECTIVO', etiqueta: 'Día no lectivo'),
    (tipo: 'EVALUACION', etiqueta: 'Evaluación / exámenes'),
    (tipo: 'OTRO', etiqueta: 'Otro'),
  ];

  Widget _buildLegend(bool isDarkMode) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode ? Colors.white : Colors.black),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Leyenda',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            children: [
              for (final item in _leyenda)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _colorBasedType(item.tipo),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Text(item.etiqueta),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determina si es un tema oscuro, sirve para cambiar el color del borde de las cajitas, dias bloqueados, etc
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario escolar'),
        actions: [
          IconButton(
            tooltip: 'Recargar',
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _loadEvents,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_loading) const LinearProgressIndicator(),
          if (_error != null)
            MaterialBanner(
              content: Text(_error!),
              actions: [
                TextButton(
                  onPressed: _loadEvents,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          TableCalendar<Event>(
            // Esto permite que los siguientes textos esten en castellano
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mes',
              CalendarFormat.twoWeeks: '2 semanas',
              CalendarFormat.week: 'Semana',
            },
            // Los textos generales estaran en castellano
            locale: 'es_ES',
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            // Permite cambiar el color de la cabecera, en este caso es para el boton de '2 semanas', 'semana', 'mes', etc
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              formatButtonDecoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            calendarStyle: const CalendarStyle(
              markersMaxCount: 0,
              canMarkersOverflow: false,
              outsideDaysVisible: true,
            ),
            calendarBuilders: CalendarBuilders(
              // Día normal
              defaultBuilder: (context, day, focusedDay) =>
                  _buildBlockedDay(day),
              // Día de hoy (si no está bloqueado devuelve null y se ve el de siempre)
              todayBuilder: (context, day, focusedDay) =>
                  _buildBlockedDay(day),
              // Día seleccionado (si no está bloqueado se ve el de siempre)
              selectedBuilder: (context, day, focusedDay) =>
                  _buildBlockedDay(day, selected: true),
              // Días de otro mes (se ven en "2 semanas" y "Semana"): son los
              // que faltaban para que la barra continúe al cambiar de mes
              outsideBuilder: (context, day, focusedDay) =>
                  _buildBlockedDay(day, outside: true),
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 24.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Leyenda de colores, aprovechando el espacio libre de abajo
          _buildLegend(isDarkMode),
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: 1),
    );
  }
}