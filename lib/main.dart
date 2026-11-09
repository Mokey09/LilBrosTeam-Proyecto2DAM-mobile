import 'package:flutter/material.dart';
// 1. Importa la librería intl para la localización de fechas
import 'package:intl/date_symbol_data_local.dart';
import 'package:synkra_app/pages/calendar_screen.dart';
import 'package:synkra_app/pages/home_screen.dart';
import 'pages/login_screen.dart';

// TODO no debe ir directamente a HomeScreen,
// TODO debe pasar antes por el login de usuario y entonces ya HomeScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa los formatos de fecha para español
  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        'home_screen': (_) => HomeScreen(),
        'calendar_screen': (_) => CalendarScreen(),
        'login_screen': (_) => LoginScreen(),
      },
    );
  }
}