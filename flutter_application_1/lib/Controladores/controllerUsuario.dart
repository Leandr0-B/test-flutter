import 'package:flutter/material.dart';
import 'package:flutter_application_1/Modelo/usuario.dart';
import 'package:flutter_application_1/UI/vistaInicio.dart';
import 'package:flutter_application_1/Servicios/facade.dart';
import '../UI/vistaLogin.dart';

class ControllerUsuario {
  //Atributos
  Function(String mensaje) mostrarMensaje;
  Function() ingreso;

  //Constructor
  ControllerUsuario({
    required this.mostrarMensaje,
    required this.ingreso,
  });

  //Funciones
  void loginUsuario(String email, String clave) {
    String? control = _controlDatos(email, clave);
    if (control == null) {
      Usuario? usuario = Facade.getInstancia()?.ingresoAplicacion(email, clave);
      if (usuario == null) {
        mostrarMensaje("Los datos ingresados no estan en el sistema.");
      } else {
        ingreso();
      }
    } else {
      mostrarMensaje(control);
    }
  }

  String? _controlDatos(String email, String clave) {
    if (email == "" || clave == "") {
      return "Los datos de ingreso no pueden estar vacios";
    } else {
      final RegExp regex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
      );
      if (!regex.hasMatch(email)) {
        return "El correo ingresado no es valido.";
      } else {
        return null;
      }
    }
  }
}
