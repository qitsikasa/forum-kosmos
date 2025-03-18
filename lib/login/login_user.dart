import 'package:flutter/material.dart';
import 'package:forum/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Auth _auth = Auth();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
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
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
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
            GestureDetector(
              onTap: login,
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
                    "Iniciar Sesión",
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

  void login() async {
    if (keyForm.currentState?.validate() ?? false) {
      try {
        await _auth.signInWithEmailAndPassword(emailCtrl.text, passwordCtrl.text);
        print("Inicio de sesión exitoso");

        // Navegar a la pantalla principal o mostrar un mensaje de éxito
        Navigator.of(context).pop(); // Por ejemplo, regresar a la pantalla anterior
      } catch (e) {
        setState(() {
          _errorMessage = "Error al iniciar sesión: ${e.toString()}";
        });
      }
    }
  }
}