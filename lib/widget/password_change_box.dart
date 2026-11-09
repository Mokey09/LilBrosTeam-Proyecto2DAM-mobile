import 'package:flutter/material.dart';

//https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/

class PasswordDialogBox extends StatefulWidget {
  const PasswordDialogBox({super.key});

  @override
  State<PasswordDialogBox> createState() => _PasswordDialogBox();
}

class _PasswordDialogBox extends State<PasswordDialogBox> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Text("Cambiar contraseña"),
      contentPadding: EdgeInsets.only(
        left: 25,
        right: 25,
        top: 10,
        bottom: 30,
      ),
      content: SizedBox(
        child: TextField(
          obscureText: _obscureText,
          cursorColor: Colors.indigoAccent,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo),
            ),
            hintText: "Nueva contraseña",
            suffixIcon: IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              }
            ),
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          color: Colors.indigoAccent,
          textColor: Colors.white,
          child: Text("Cambiar"),
          onPressed: () {
            // TODO cambiar contrasena
          },
        ),
      ],
    );
  }
}