import 'package:flutter/material.dart';
import 'package:synkra_app/models/profesor.dart';
import 'package:synkra_app/services/api_client.dart';
import 'package:synkra_app/services/auth_service.dart';
import 'package:synkra_app/widget/nav_bar.dart';
import 'package:synkra_app/widget/password_change_box.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
    final textTheme = Theme.of(context).textTheme;
    final p = _profesor;

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
      body: Column(
        children: [
          if (_loading) const LinearProgressIndicator(),
          if (_error != null)
            MaterialBanner(
              content: Text(_error!),
              actions: [
                TextButton(onPressed: _load, child: const Text('Reintentar')),
              ],
            ),
          Expanded(
            child: p == null
                ? const SizedBox.shrink()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // TODO hay que cambiar el icono por una imagen del profesor
                            // https://www.youtube.com/watch?v=ux8qGI8hH70
                            const Icon(
                              Icons.account_circle,
                              size: 150,
                              color: Color.fromARGB(221, 26, 26, 26),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // TODO
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.indigoAccent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          p.nombreCompleto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _Field(label: 'Email', value: p.email),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // La API nunca devuelve la contraseña
                            const Expanded(
                              child: _Field(
                                label: 'Contraseña',
                                value: '••••••••',
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigoAccent,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const PasswordDialogBox();
                                  },
                                );
                              },
                              child: const Text(
                                'Cambiar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _Field(label: 'Cuerpo', value: p.cuerpo),
                            ),
                            Expanded(
                              child: _Field(label: 'Rol', value: p.rol),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _Field(label: 'DNI', value: p.dni),
                            ),
                            Expanded(
                              child:
                                  _Field(label: 'Teléfono', value: p.telefono),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _Field(
                                label: 'Departamento',
                                value: p.departamento,
                              ),
                            ),
                            Expanded(
                              child: _Field(
                                label: 'Especialidad',
                                value: p.especialidad,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _Field(
                          label: 'Dirección',
                          value: [
                            p.direccion,
                            p.codigoPostal?.toString(),
                            p.localidad,
                          ].where((e) => e != null && e.isNotEmpty).join(', '),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Horario semanal",
                                style: textTheme.labelMedium),
                            // TODO aqui hay que renderizar la tabla del horario semanal del profesor
                            // (GET /sesiones/profesor/{dni} exige rol GESTOR o DIRECTOR en la API)
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      // TODO esta barra de navegacion debe ser borrada una vez implementado el
      // TODO sistema de login
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }
}

/// Etiqueta + valor. Si el dato no existe en la API se muestra un guion.
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: textTheme.labelMedium),
        Text(
          (value == null || value!.isEmpty) ? '—' : value!,
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
