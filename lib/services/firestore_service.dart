import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Auth _auth = Auth(); // Instancia de la clase Auth

  // Agregar usuario a Firestore con verificación de username único
  Future<void> addUser(String name, String email, String password) async {
    try {
      // Verificar si el username ya existe
      final querySnapshot = await _db.collection('usuarios').where('username', isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('El nombre de usuario ya está en uso.');
      }

      // Crear usuario con Firebase Authentication a través de Auth
      await _auth.createUserWithEmailAndPassword(email, password);

      // Obtener el UID del usuario autenticado
      final userId = _auth.user?.uid;
      if (userId == null) {
        throw Exception('No se pudo obtener el UID del usuario.');
      }

      // Agregar datos del usuario a Firestore
      await _db.collection('usuarios').doc(userId).set({
        'username': name,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Usuario registrado y datos guardados en Firestore.");
    } catch (e) {
      print('Error al agregar usuario: $e');
      rethrow; // Vuelve a lanzar el error para manejarlo en la interfaz de usuario
    }
  }

  // Obtener usuarios en tiempo real
  Stream<QuerySnapshot> getUsers() {
    return _db.collection('usuarios').orderBy('timestamp').snapshots();
  }
}
