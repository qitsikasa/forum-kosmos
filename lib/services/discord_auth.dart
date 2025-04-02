import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_html/html.dart' as html;

class DiscordAuthService {
  final String clientId = '1351586046155948032';
  final String clientSecret = 'BpUDGzj6j4PAx8m9XcXMS603p73TmzDu';
  final String redirectUri = 'http://localhost:50125';  // Cambiado a solo localhost:50125

  Future<void> loginWithDiscord() async {
    try {
      final authUrl = Uri.https('discord.com', '/api/oauth2/authorize', {
        'response_type': 'code',
        'client_id': clientId,
        'scope': 'identify email',
        'redirect_uri': redirectUri,
        'prompt': 'consent'
      });

      // Abre la URL en la misma ventana
      html.window.location.href = authUrl.toString();
    } catch (e) {
      print('Error al iniciar sesión con Discord: $e');
    }
  }


  Future<void> handleRedirect(String code) async {
    try {
      print('Iniciando intercambio de código por token...');
      
      final response = await http.post(
        Uri.parse('https://discord.com/api/oauth2/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Error en la respuesta del servidor: ${response.body}');
      }

      final tokenData = json.decode(response.body);
      final accessToken = tokenData['access_token'];

      print('Token obtenido exitosamente');

      // Obtener información del usuario
      final userResponse = await http.get(
        Uri.parse('https://discord.com/api/users/@me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (userResponse.statusCode != 200) {
        throw Exception('Error al obtener datos del usuario: ${userResponse.body}');
      }

      final userData = json.decode(userResponse.body);
      
      // Crear usuario en Firebase
      await _createFirebaseUser(
        email: userData['email'],
        username: userData['username'],
        discordId: userData['id'],
        avatar: userData['avatar'],
      );

      // Redirigir a la página principal o mostrar mensaje de éxito
      html.window.location.href = '/';

    } catch (e) {
      print('Error en handleRedirect: $e');
      // Redirigir a una página de error o mostrar mensaje
      html.window.location.href = '/error';
    }
  }

  Future<void> _createFirebaseUser({
    required String email,
    required String username,
    required String discordId,
    String? avatar,
  }) async {
    try {
      // Generar una contraseña aleatoria segura
      final password = DateTime.now().millisecondsSinceEpoch.toString();

      // Crear usuario en Firebase Auth
      final UserCredential userCredential = 
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar datos adicionales en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'discordId': discordId,
        'avatar': avatar,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });

      print('Usuario registrado exitosamente: $email');
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          // Si el usuario ya existe, intentar iniciar sesión
          await _signInExistingUser(email);
        } else {
          print('Error de Firebase Auth: ${e.message}');
          rethrow;
        }
      } else {
        print('Error al crear usuario: $e');
        rethrow;
      }
    }
  }

  Future<void> _signInExistingUser(String email) async {
    try {
      // Actualizar último login
      final query = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      print('Usuario existente actualizado: $email');
    } catch (e) {
      print('Error al actualizar usuario existente: $e');
      rethrow;
    }
  }
}