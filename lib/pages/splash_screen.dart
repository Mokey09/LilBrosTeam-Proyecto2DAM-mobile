import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

// documentacion : https://stackoverflow.com/questions/43879103/adding-a-splash-screen-to-flutter-apps

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Duración GIF
  static const gifDuration = Duration(milliseconds: 2520);

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future.wait([
      Future.delayed(gifDuration),
      _loadData(), // TODO
    ]);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _loadData() async {
    // Carga de sesión, configuración, etc. todo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // mismo color que el fondo del GIF
      body: Center(
        child: Image.asset(
          'assets/logoGif.gif',
          width: 200,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}