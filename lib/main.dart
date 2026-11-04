import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'pages/calendar_screen.dart';

import 'pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pone la fecha del calendario en tipo Espana
  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarScreen(),
    );
  }
}