import 'package:flutter/material.dart';
import 'package:retos_proyecto/splashScreen.dart';
import 'package:retos_proyecto/vista_tutor/TabPages/TaPagesSala.dart';
import 'package:retos_proyecto/vista_tutorado/Salas/ListaMisiones.dart';

import 'Servicios/Autenticacion/DatosNewUser.dart';
import 'Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerEmail.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerPassw.dart';
import 'Servicios/Autenticacion/login.dart';
import 'main.dart';

class Rutas{
  static dynamic getRutas(){
    return{
      '/': (context) => const MyHomePage(),
      Login.ROUTE_NAME: (context) => const Login(),
      Roll.ROUTE_NAME: (context) => const Roll(),
      StateNombreUsuario.ROUTE_NAME: (context) => const NombreUsuario(),
      IniSesionEmailPassword.ROUTE_NAME: (context) =>
      const IniSesionEmailPassword(),
      Inicio.ROUTE_NAME: (context) => const Inicio(),
      ListaMisiones.ROUTE_NAME: (context) => const ListaMisiones(),
      TabPagesSala.ROUTE_NAME: (context) => const TabPagesSala(),
      RecogerPassw.ROUTE_NAME: (context) => const RecogerPassw(),
      RecogerEmail.ROUTE_NAME: (context) => const RecogerEmail(),
      IniSesionEmailPassword.ROUTE_NAME: (context) => const IniSesionEmailPassword(),
    };
  }
}