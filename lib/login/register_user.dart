// Crear un nuevo usuario en Firestore
import 'package:flutter/material.dart';
import 'package:forum/services/firestore_service.dart';
import 'package:forum/services/discord_auth.dart';
import 'package:universal_html/html.dart' as html;




class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final DiscordAuthService _discordAuthService = DiscordAuthService();

  final FirestoreService _firestoreService = FirestoreService();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController repeatPassCtrl = TextEditingController();

  bool _isCodeProcessed = false;

  @override
  void initState() {
    super.initState();
    // Verifica el código de autorización al cargar la página
    final uri = Uri.parse(html.window.location.href);
    if (uri.queryParameters.containsKey('code')) {
      final code = uri.queryParameters['code']!;
      _handleDiscordCallback(code);
    }
  }

  Future<void> _handleDiscordCallback(String code) async {
  try {
    if (_isCodeProcessed) {
      print('Código ya procesado, ignorando...');
      return;
    }

    print('Procesando código de Discord: $code');
    setState(() {
      _isCodeProcessed = true;
    });
    
    await _discordAuthService.handleRedirect(code);
    print('Proceso de registro completado');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registro exitoso con Discord'),
        backgroundColor: Colors.green,
      ),
    );

    // Opcional: navegar a otra página después del registro exitoso
    // Navigator.of(context).pushReplacementNamed('/home');
  } catch (e) {
    print('Error detallado en el registro con Discord: $e');
    setState(() {
      _isCodeProcessed = false; // Permite reintentar en caso de error
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error en el registro: ${e.toString()}'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: keyForm,
            child: formUI(),
          ),
        ),
      ),
    );
  }
  Widget formItemsDesign(IconData icon, Widget item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  Widget formUI() {
    return Center(
      child: SizedBox(
        width: 500,
        child: Column(
          children: <Widget>[
            formItemsDesign(
              Icons.person,
              TextFormField(
                controller: usernameCtrl,
                decoration: InputDecoration(labelText: 'Nombre De Usuario'),
                maxLength: 32,
                validator: validateUserName,
              ),
            ),
            formItemsDesign(
              Icons.email,
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                maxLength: 32,
                validator: validateEmail,
              ),
            ),
            formItemsDesign(
              Icons.remove_red_eye,
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: validatePassword,
              ),
            ),
            formItemsDesign(
              Icons.remove_red_eye,
              TextFormField(
                controller: repeatPassCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Repetir la Contraseña'),
                validator: validateRepeatPassword,
              ),
            ),
            formItemsDesign(
              Icons.discord,
              ElevatedButton.icon(
                onPressed: _discordAuthService.loginWithDiscord,
                icon: Icon(Icons.discord),
                label: Text('Registrarse con Discord'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5865F2), // Color oficial de Discord
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: save,
              child: Container(
                margin: EdgeInsets.all(30.0),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0EDED2),
                      Color(0xFF03A0FE),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Guardar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
          
        ),
      ),
    );
  }

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return "El nombre es necesario";
    }
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "El nombre debe ser solo letras a-z y A-Z";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "El correo es necesario";
    }
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Correo inválido";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "La contraseña es necesaria";
    }
    return null;
  }

  String? validateRepeatPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Debes repetir la contraseña";
    }
    if (value != passwordCtrl.text) {
      return "Las contraseñas no coinciden";
    }
    return null;
  }

  void save() async {
    if (keyForm.currentState?.validate() ?? false) {
      // Construye el mapa del nuevo usuario
      Map<String, dynamic> user = {
        'username': usernameCtrl.text,
        'email': emailCtrl.text,
        'password': passwordCtrl.text,
      };

      // Guardar el usuario en Firestore usando FirestoreService
      await _firestoreService.addUser(user['username'], user['email'], user['password']);

      setState(() {
        usernameCtrl.clear();
        emailCtrl.clear();
        passwordCtrl.clear();
        repeatPassCtrl.clear();
        keyForm.currentState?.reset();
      });
    }
  }
}