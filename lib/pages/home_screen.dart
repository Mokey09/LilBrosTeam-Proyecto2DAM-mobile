import 'package:flutter/material.dart';
import 'package:synkra_app/widget/nav_bar.dart';
import 'calendar_screen.dart';
import 'login_screen.dart';
import 'user_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.userName = 'Alberto', // TODO: sustituir por el usuario autenticado
    this.profileImageUrl, // TODO: foto de perfil del usuario
  });

  final String userName;
  final String? profileImageUrl;

  // Colores del diseño. Si ya los tienes en el ThemeData, cámbialos por
  // Theme.of(context).colorScheme.
  static const _blue = Color(0xFF4F6BFF);
  static const _amber = Color(0xFFFFC107);
  static const _lavender = Color(0xFFDDE2FF);

  void _openProfile(BuildContext context) {
    // TODO: navegar a la pantalla de perfil
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserScreen()),
    );
  }

  void _requestDay(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalendarScreen()),
    );
  }

  void _openHistory(BuildContext context) {
    // TODO: navegar al historial de días moscosos
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalendarScreen()),
    );
  }

  void _openSchoolInfo(BuildContext context) {
    // TODO: navegar a los datos del centro
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalendarScreen()),
    );
  }

  void _openCalendar(BuildContext context) {
    // TODO: navegar al calendario escolar
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalendarScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: Text(
          'Hola, $userName',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Semantics(
              button: true,
              label: 'Ir al perfil',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _openProfile(context),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _blue,
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: _lavender,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(Icons.person, color: _blue, size: 28)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _HomeButton(
                      icon: Icons.edit_calendar,
                      label: 'Solicitar día moscoso',
                      background: _blue,
                      foreground: Colors.white,
                      onTap: () => _requestDay(context),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _HomeButton(
                      icon: Icons.history,
                      label: 'Historial de días moscosos',
                      background: _amber,
                      foreground: Colors.black87,
                      onTap: () => _openHistory(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _HomeButton(
                      icon: Icons.location_city,
                      label: 'Datos del centro',
                      background: Colors.white,
                      foreground: Colors.black87,
                      outlined: true,
                      onTap: () => _openSchoolInfo(context),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _HomeButton(
                      icon: Icons.calendar_month,
                      label: 'Calendario escolar',
                      background: _lavender,
                      foreground: Colors.black87,
                      onTap: () => _openCalendar(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }
}

class _HomeButton extends StatelessWidget {
  const _HomeButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.outlined = false,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);

    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: outlined
            ? const BorderSide(color: Colors.black87, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 44, color: foreground),
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}