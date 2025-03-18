import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forum/login/register_user.dart';
import 'services/firebase_options.dart';
import 'login/login_user.dart';
import 'services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ForoClasicoApp());
}

class ForoClasicoApp extends StatelessWidget {
  const ForoClasicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        scaffoldBackgroundColor: Color(0xFFD8EFFF), // Azul pastel Windows ME
      ),
      home: ForoHomePage(),
    );
  }
}

class ForoHomePage extends StatelessWidget {
  const ForoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/win_me_logo.svg',
              height: 30,
            ),
            SizedBox(width: 10),
            Text("Foro Windows ME", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final user = snapshot.data!;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Iniciaste sesión como: ${user.email}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          final auth = Auth();
                          await auth.signOut();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sesión cerrada correctamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Text(
                          "Cerrar Sesión",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      "No has iniciado sesión",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 18, 180, 249), // Azul Windows ME
        elevation: 8,
        shadowColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 275,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB3E0FF), Color(0xFF66CCFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF007ACC), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                    blurRadius: 15,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "¡Bienvenido al Foro Windows ME!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Explora los hilos y revive la era dorada del internet",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 40),
                  Text("Si eres nuevo registrate:", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A2E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadowColor: Colors.blueAccent,
                      elevation: 10,
                    ),
                    onPressed: () {
                      // Navegar a la página de login
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text("Iniciar Sesion", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  Text("Si eres nuevo registrate:", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A2E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadowColor: Colors.blueAccent,
                      elevation: 10,
                    ),
                    onPressed: () {
                      // Navegar a la página de register
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text("Crea Una Cuenta", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
