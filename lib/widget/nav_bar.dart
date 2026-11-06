import 'package:flutter/material.dart';

//https://api.flutter.dev/flutter/material/NavigationBar-class.html

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior = .alwaysShow;

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      // Asi no hay que repetir algunos colores en muchas propiedades
      data: NavigationBarThemeData(
        backgroundColor: Colors.indigoAccent,
        indicatorColor: Colors.amber,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (states) => const IconThemeData(color: Colors.white),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) => const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.indigoAccent,
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;

            if (currentPageIndex == 0) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'home_screen',
                (route) => false,
              );
            } else if (currentPageIndex == 1) {
              Navigator.pushNamedAndRemoveUntil(
                context, 
                'calendar_screen',
                (route) => false,
              );
            } else if (currentPageIndex == 2) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'login_screen',
                (route) => false,
              );
            }
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      )
    );
  }
}