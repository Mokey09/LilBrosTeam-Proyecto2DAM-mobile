import '../models/profesor.dart';
import 'api_client.dart';
import 'token_storage.dart';

/// Sesión actual: quién ha iniciado sesión y cómo cerrarla.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Profesor? profesor;

  Future<void> login(String email, String contrasena) async {
    await ApiClient.instance.login(email, contrasena);
    profesor = await ApiClient.instance.me();
  }

  /// Al abrir la app: si hay token guardado, el servidor decide si vale.
  /// Devuelve true si hay sesión válida.
  /// Lanza ApiException si no se pudo comprobar (sin conexión, servidor caído).
  Future<bool> restoreSession() async {
    final token = await TokenStorage.read();
    if (token == null) return false;
    try {
      profesor = await ApiClient.instance.me();
      return true;
    } on UnauthorizedException {
      profesor = null; // token caducado: ApiClient ya lo ha borrado
      return false;
    }
  }

  Future<void> logout() async {
    profesor = null;
    await TokenStorage.clear();
  }
}
