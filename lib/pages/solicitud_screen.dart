import 'package:flutter/material.dart';
import 'package:synkra_app/main.dart'; // themeNotifier
import 'package:synkra_app/models/profesor.dart';
import 'package:synkra_app/services/api_client.dart';
import 'package:synkra_app/services/auth_service.dart';
import 'package:synkra_app/widget/nav_bar.dart';

class SolicitudScreen extends StatefulWidget {
  const SolicitudScreen({super.key});

  @override
  State<SolicitudScreen> createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends State<SolicitudScreen> {
  // Se muestra al instante lo que ya se cargó en el login y se refresca desde la API
  Profesor? _profesor = AuthService.instance.profesor;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profesor = await ApiClient.instance.me();
      AuthService.instance.profesor = profesor;
      if (!mounted) return;
      setState(() {
        _profesor = profesor;
        _loading = false;
      });
    } on UnauthorizedException {
      _goToLogin();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('login_screen', (r) => false);
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    _goToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perfil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: const Column(
        // Agrega aquí los hijos de la columna cuando los necesites
        children: [],
      ),
      // TODO esta barra de navegacion debe ser borrada una vez implementado el
      // TODO sistema de login
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }
}