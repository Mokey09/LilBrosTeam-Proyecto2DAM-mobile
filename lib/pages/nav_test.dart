import 'package:flutter/material.dart';
import 'package:synkra_app/widget/nav_bar.dart';

// TODO borrar esta pantalla, solo sirve de prueba para el diseno
// de la barra, despues es simplemente anadir bottomNavigationBar en las pantallas

class NavigationTest extends StatefulWidget {
  const NavigationTest({super.key});

  @override
  State<NavigationTest> createState() => _NavigationTestState();
}

class _NavigationTestState extends State<NavigationTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO justo despues del body de cada pagina
      bottomNavigationBar: NavBar()
    );
  }
}