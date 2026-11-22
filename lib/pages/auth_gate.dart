import 'package:flutter/material.dart';
import 'package:synkra_app/services/auth_service.dart';

/// Pantalla de arranque: comprueba el token guardado contra la API
/// y decide si ir al Home o al login.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    setState(() => _error = null);
    try {
      final valid = await AuthService.instance.restoreSession();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        valid ? 'home_screen' : 'login_screen',
      );
    } catch (e) {
      // Sin conexión o servidor caído: no sabemos si el token vale, no se borra
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _error == null
            ? const CircularProgressIndicator(color: Colors.indigoAccent)
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 64),
                    const SizedBox(height: 16),
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                      ),
                      onPressed: _check,
                      child: const Text('Reintentar',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed('login_screen'),
                      child: const Text('Ir al login'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
