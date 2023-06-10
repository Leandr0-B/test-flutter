import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controladores/controllerUsuario.dart';
import 'package:flutter_application_1/UI/iVistaLogin.dart';
import 'package:flutter_application_1/UI/vistaInicio.dart';

class LoginPage extends StatefulWidget {
  static String id = 'vistaLogin';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements IvistaLogin {
  String _correo = '';
  String _clave = '';
  ControllerUsuario? controller;

  @override
  void initState() {
    super.initState();
    controller = ControllerUsuario(
      mostrarMensaje: mostrarMensaje,
      ingreso: ingreso,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: FractionallySizedBox(
          widthFactor: 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Iniciar Sesión', // Título
                style: TextStyle(
                  fontSize: 24, // Tamaño de fuente
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              _userTextField(),
              SizedBox(
                height: 15,
              ),
              _passwordTextField(),
              SizedBox(
                height: 50,
              ),
              _bottonLogin(),
            ],
          ),
        )),
      ),
    );
  }

  Widget _userTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electronico',
            ),
            onChanged: (value) {
              _correo = value;
            },
          ),
        );
      },
      stream: null,
    );
  }

  Widget _passwordTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Contraseña',
              labelText: 'Contraseña',
            ),
            onChanged: (value) {
              _clave = value;
            },
          ),
        );
      },
      stream: null,
    );
  }

  Widget _bottonLogin() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          onPressed: _eventoLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            elevation: 10.0,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
        );
      },
      stream: null,
    );
  }

  void _eventoLogin() {
    controller?.loginUsuario(_correo, _clave);
    print("Usuario: {$_correo}  Clave: {$_clave}");
  }

  @override
  void ingreso() {
    Navigator.pushReplacementNamed(context, InicioPage.id);
  }

  @override
  void mostrarMensaje(String mensaje) {
    final snackBar = SnackBar(content: Text(mensaje));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
