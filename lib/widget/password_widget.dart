import 'package:flutter/material.dart';

// https://medium.com/@applelappala/show-hide-password-in-flutter-how-i-do-it-1000e94e7574

// La contrasena cambia de estado (visible/no visible)
class PasswordField extends StatefulWidget {
  // Controller opcional para poder leer lo escrito (p. ej. en el login)
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  const PasswordField({super.key, this.controller, this.onSubmitted});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: widget.onSubmitted,
      obscureText: _obscureText,
      cursorColor: Colors.indigoAccent,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: 'Contraseña', 
        floatingLabelStyle: TextStyle(
          color: Colors.indigoAccent,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.indigoAccent),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          }
        ),
      )
    );
  }
}