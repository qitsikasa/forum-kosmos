import 'dart:convert';
import 'dart:html' as html; // Import para Flutter Web
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController repeatPassCtrl = TextEditingController();

  String gender = 'hombre';

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
      child: Container(
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

      // Usar LocalStorage para Flutter Web
      List<dynamic> users = [];
      final jsonData = html.window.localStorage['usuarios'];
      if (jsonData != null && jsonData.isNotEmpty) {
        try {
          users = jsonDecode(jsonData);
        } catch (e) {
          users = [];
        }
      }

      users.add(user);
      html.window.localStorage['usuarios'] = jsonEncode(users);
      print("Usuarios actualizados: ${jsonEncode(users)}");

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