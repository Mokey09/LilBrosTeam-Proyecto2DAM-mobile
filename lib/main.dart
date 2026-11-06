import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'pages/home_screen.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  // Mantiene el splash nativo visible hasta que llamemos a remove()
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  try {
    await _loadData().timeout(const Duration(seconds: 5));
  } catch (_) {
    // Un fallo o timeout no debe dejar la app bloqueada en el splash
  }

  // Quita el splash nativo cuando todo está listo
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

Future<void> _loadData() async {
  // Carga de sesión, configuración, etc.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}