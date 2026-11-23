import 'package:flutter/material.dart';
// 1. Importa la librería intl para la localización de fechas
import 'package:intl/date_symbol_data_local.dart';
import 'package:synkra_app/pages/auth_gate.dart';
import 'package:synkra_app/pages/calendar_screen.dart';
import 'package:synkra_app/pages/home_screen.dart';
import 'pages/login_screen.dart';
import 'pages/user_screen.dart';

// TODO no debe ir directamente a HomeScreen,
// TODO debe pasar antes por el login de usuario y entonces ya HomeScreen

// Valor por defecto del tema (el del sistema) y del notifier
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa los formatos de fecha para español
  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _dark = Color(0xFF171717);
  static const _light = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    // Aqui se escucha si han habido cambios de tema a nivel global
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: _light,
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                colorSchemeSeed: _dark,
                scaffoldBackgroundColor: _dark,
              ),
              // En que tema actual se encuentra (oscuro/claro)
              themeMode: currentThemeMode,
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
              routes: {
                'home_screen': (_) => HomeScreen(),
                'calendar_screen': (_) => CalendarScreen(),
                'user_screen': (_) => UserScreen(),
                'login_screen': (_) => LoginScreen(),
              },
            );
      }
    );
  }
}
