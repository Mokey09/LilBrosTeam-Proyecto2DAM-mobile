import 'package:flutter/material.dart';
import 'package:synkra_app/widget/nav_bar.dart';

// TODO pantalla inicial, en esta pantalla habran dos botones para
// TODO solicitar dias y ver un historial de las solicitudes

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
      bottomNavigationBar: NavBar(currentIndex: 0,)
    );
  }
}