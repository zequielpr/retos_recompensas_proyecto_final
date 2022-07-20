import 'package:firebase_auth/firebase_auth.dart';

class Validar {
  static bool validarEmail(String email) {
    return RegExp(
            r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$")
        .hasMatch(email);
  }

  static bool validarPassw(String passw) {
    return RegExp(
            r'^(?=.*\d)(?=.*[\u0021-\u002b\u003c-\u0040])(?=.*[a-z])\S{1,16}$')
        .hasMatch(passw);
  }

  static bool validarUserName(String userName){
    print('is valid: ${RegExp(r"^[A-Za-z0-9]+(?:[_][A-Za-z0-9]+)*([_]?)$").hasMatch(userName)}');
    return RegExp(r"^[A-Za-z0-9]+(?:[_][A-Za-z0-9]+)*([_]?)$").hasMatch(userName);
  }
}
