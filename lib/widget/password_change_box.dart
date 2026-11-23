import 'package:flutter/material.dart';
import 'package:synkra_app/services/api_client.dart';

//https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/

class PasswordDialogBox extends StatefulWidget {
  const PasswordDialogBox({super.key});

  @override
  State<PasswordDialogBox> createState() => _PasswordDialogBox();
}

class _PasswordDialogBox extends State<PasswordDialogBox> {
  final _actualController = TextEditingController();
  final _nuevaController = TextEditingController();
  final _repetirController = TextEditingController();
  bool _obscureText = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _actualController.dispose();
    _nuevaController.dispose();
    _repetirController.dispose();
    super.dispose();
  }

  Future<void> _cambiar() async {
    final actual = _actualController.text;
    final nueva = _nuevaController.text;

    if (actual.isEmpty || nueva.isEmpty) {
      setState(() => _error = 'Rellena todos los campos');
      return;
    }
    if (nueva.length < 8) {
      setState(() => _error = 'La nueva contraseña debe tener al menos 8 caracteres');
      return;
    }
    if (nueva != _repetirController.text) {
      setState(() => _error = 'Las contraseñas nuevas no coinciden');
      return;
    }
    if (nueva == actual) {
      setState(() => _error = 'La nueva contraseña debe ser distinta');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    // Se guardan antes del await para no usar el context después
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await ApiClient.instance.cambiarContrasena(actual, nueva);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Contraseña cambiada correctamente')),
      );
    } on UnauthorizedException {
      // Token caducado: de vuelta al login
      navigator.pushNamedAndRemoveUntil('login_screen', (route) => false);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (e) {
      // Cualquier otro fallo (respuesta rara, error de red no previsto...)
      if (!mounted) return;
      setState(() {
        _error = 'Error inesperado: $e';
        _loading = false;
      });
    }
  }

  InputDecoration _decoration(String hint, {bool toggle = false}) {
    return InputDecoration(
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.indigo),
      ),
      hintText: hint,
      suffixIcon: toggle
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: const Text("Cambiar contraseña"),
      contentPadding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 10,
        bottom: 30,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _actualController,
              obscureText: _obscureText,
              cursorColor: Colors.indigoAccent,
              decoration: _decoration("Contraseña actual", toggle: true),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nuevaController,
              obscureText: _obscureText,
              cursorColor: Colors.indigoAccent,
              decoration: _decoration("Nueva contraseña (mínimo 8 caracteres)"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _repetirController,
              obscureText: _obscureText,
              cursorColor: Colors.indigoAccent,
              decoration: _decoration("Repite la nueva contraseña"),
              onSubmitted: (_) => _cambiar(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        MaterialButton(
          color: Colors.indigoAccent,
          textColor: Colors.white,
          onPressed: _loading ? null : _cambiar,
          child: _loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("Cambiar"),
        ),
      ],
    );
  }
}
