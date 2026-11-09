import 'package:flutter/material.dart';
import 'package:synkra_app/widget/nav_bar.dart';
import 'home_screen.dart';
import 'package:synkra_app/widgets/password_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 150, color: const Color.fromARGB(221, 26, 26, 26),),
            const Text(
              "Iniciar sesión",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const TextField(
              maxLength: 20,
              cursorColor: Colors.indigoAccent,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.numbers),
                labelText: 'Código',
                floatingLabelStyle: TextStyle(
                  color: Colors.indigoAccent,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigoAccent),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const PasswordField(),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text('Entrar', style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(currentIndex: 2,),
    );
  }
}
