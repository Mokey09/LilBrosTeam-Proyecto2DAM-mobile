import 'package:flutter/material.dart';
import 'package:synkra_app/widget/nav_bar.dart';
import 'package:synkra_app/widget/password_change_box.dart';
import 'package:synkra_app/widget/password_widget.dart';
import 'home_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Perfil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // TODO hay que cambiar el icono por una imagen del profesor
                // https://www.youtube.com/watch?v=ux8qGI8hH70
                Icon(Icons.account_circle, size: 150, color: const Color.fromARGB(221, 26, 26, 26),),
                Positioned(
                  bottom: 0, right: 0,
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
                )
              ],
            ),
            const Text(
              "Nombre completo del profesor",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nombre del usuario",
                  style: textTheme.labelMedium,
                ),
                Text(
                  "user.nombreUsuario",
                  style: textTheme.bodyLarge,
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Contraseña",
                        style: textTheme.labelMedium,
                      ),
                      Text(
                        "user.contrasena",
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  //width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const PasswordDialogBox(); // O el nombre correcto de tu clase
                        },
                      );
                    },
                    child: const Text('Cambiar', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cuerpo",
                        style: textTheme.labelMedium,
                      ),
                      Text(
                        "user.cuerpo",
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rol",
                        style: textTheme.labelMedium,
                      ),
                      Text(
                        "user.rol",
                        style: textTheme.bodyLarge,
                      ),
                    ]
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Horario semanal",
                  style: textTheme.labelMedium,
                ),
                // TODO aqui hay que renderizar la tabla del horario semanal del profesor
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      // TODO esta barra de navegacion debe ser borrada una vez implementado el
      // TODO sistema de login
      bottomNavigationBar: NavBar(currentIndex: 2,),
    );
  }
}