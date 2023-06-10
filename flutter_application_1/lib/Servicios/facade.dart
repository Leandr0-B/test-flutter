import 'package:flutter_application_1/Modelo/usuario.dart';

class Facade {
  //Atributos
  static Facade? instancia = null;

  //Constructor
  static Facade? getInstancia() {
    if (instancia == null) {
      instancia = new Facade();
    }
    return instancia;
  }

  //Funciones
  //Usuario
  Usuario? ingresoAplicacion(String email, String clave) {
    if (email == 'gonza@gmail.com' && clave == '123') {
      return Usuario(email, clave);
    }
    return null;
  }
}
