import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/bloqueo.dart';
import '../models/profesor.dart';
import 'api_config.dart';
import 'token_storage.dart';

/// Error de la API con un mensaje que se puede enseñar al usuario.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// El token no existe, ha caducado o es inválido (HTTP 401).
class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'La sesión ha caducado'])
      : super(statusCode: 401);
}

/// Respuesta de POST /auth/login
class LoginResult {
  final String token;
  final int id;
  final String nombre;
  final String rol;
  const LoginResult(this.token, this.id, this.nombre, this.rol);
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: query);

  /// Ejecuta la petición traduciendo los fallos de red a ApiException.
  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('El servidor no responde. Inténtalo de nuevo.');
    } on SocketException {
      throw const ApiException('No se pudo conectar con el servidor.');
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor.');
    }
  }

  /// Petición autenticada (cabecera Authorization: Bearer <token>).
  Future<dynamic> _getAuth(String path, [Map<String, String>? query]) async {
    final token = await TokenStorage.read();
    if (token == null) throw const UnauthorizedException();

    final response = await _send(() => http.get(
          _uri(path, query),
          headers: {'Authorization': 'Bearer $token'},
        ));

    if (response.statusCode == 401) {
      await TokenStorage.clear();
      throw const UnauthorizedException();
    }
    if (response.statusCode != 200) {
      throw ApiException('Error del servidor (${response.statusCode})',
          statusCode: response.statusCode);
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // ---- Auth ----

  /// POST /auth/login. Guarda el token si el login es correcto.
  Future<LoginResult> login(String email, String contrasena) async {
    final response = await _send(() => http.post(
          _uri('/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'contrasena': contrasena}),
        ));

    if (response.statusCode == 401) {
      throw const ApiException('Email o contraseña incorrectos',
          statusCode: 401);
    }
    if (response.statusCode == 400) {
      throw const ApiException('Escribe el email y la contraseña',
          statusCode: 400);
    }
    if (response.statusCode != 200) {
      throw ApiException('Error del servidor (${response.statusCode})',
          statusCode: response.statusCode);
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<String, dynamic>;
    final result = LoginResult(
      json['token'] as String,
      json['id'] as int,
      (json['nombre'] ?? '') as String,
      (json['rol'] ?? 'USUARIO') as String,
    );
    await TokenStorage.save(result.token);
    return result;
  }

  /// GET /auth/me. Sirve a la vez para comprobar que el token sigue siendo
  /// válido y para cargar los datos del profesor.
  Future<Profesor> me() async {
    final json = await _getAuth('/auth/me') as Map<String, dynamic>;
    return Profesor.fromJson(json);
  }

  // ---- Calendario ----

  /// GET /bloqueados. Todos los días bloqueados (cualquier rol puede leerlos).
  Future<List<Bloqueo>> bloqueos() async {
    final json = await _getAuth('/bloqueados') as List<dynamic>;
    return json
        .map((e) => Bloqueo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---- Contraseña ----

  /// PUT /auth/contrasena (cualquier rol, solo sobre su propia cuenta).
  /// La API responde 204 si todo va bien y 400 si la contraseña actual no es
  /// correcta, la nueva tiene menos de 8 caracteres o es igual a la actual.
  /// Como la API no envía el texto del error, la longitud y la igualdad se
  /// validan antes en la app; un 400 aquí significa contraseña actual errónea.
  Future<void> cambiarContrasena(String actual, String nueva) async {
    final token = await TokenStorage.read();
    if (token == null) throw const UnauthorizedException();

    final response = await _send(() => http.put(
          _uri('/auth/contrasena'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'contrasenaActual': actual,
            'contrasenaNueva': nueva,
          }),
        ));

    if (response.statusCode == 401) {
      // OJO: si la API lanza un 400 (contraseña actual incorrecta, nueva no
      // válida...), Spring lo reenvía a /error y, como /error no está permitida
      // en SecurityConfig, acaba llegando como 401. Para no echar al usuario
      // por error, se comprueba si el token sigue valiendo con /auth/me.
      try {
        await me();
      } on UnauthorizedException {
        rethrow; // el token sí ha caducado (me() ya lo ha borrado)
      }
      throw const ApiException(
          'No se pudo cambiar: revisa la contraseña actual '
          '(la nueva debe tener 8 caracteres o más y ser distinta)',
          statusCode: 400);
    }
    if (response.statusCode == 400) {
      // La API manda {"message": "..."} (server.error.include-message=always)
      String mensaje = 'No se pudo cambiar la contraseña';
      try {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final m = json is Map ? json['message'] : null;
        if (m is String && m.isNotEmpty) mensaje = m;
      } catch (_) {}
      throw ApiException(mensaje, statusCode: 400);
    }
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw ApiException('Error del servidor (${response.statusCode})',
          statusCode: response.statusCode);
    }
  }
}
