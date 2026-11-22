import 'package:flutter/material.dart';
// 1. Importa la librería intl para la localización de fechas
import 'package:intl/date_symbol_data_local.dart';
import 'package:synkra_app/pages/auth_gate.dart';
import 'package:synkra_app/pages/calendar_screen.dart';
import 'package:synkra_app/pages/home_screen.dart';
import 'pages/login_screen.dart';
import 'pages/user_screen.dart';

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
      // Primero se comprueba el token guardado (AuthGate) y de ahí
      // se va a 'home_screen' o a 'login_screen'
      home: const AuthGate(),
      routes: {
        'home_screen': (_) => const HomeScreen(),
        'calendar_screen': (_) => const CalendarScreen(),
        'user_screen': (_) => const UserScreen(),
        'login_screen': (_) => const LoginScreen(),
      },
    );
  }
}
