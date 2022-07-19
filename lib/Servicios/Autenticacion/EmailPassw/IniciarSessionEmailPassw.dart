import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/DatosNewUser.dart';
import 'package:retos_proyecto/datos/TransferirDatos.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../Autenticacion.dart';

class IniSesionEmailPassword extends StatelessWidget {
  static const ROUTE_NAME = 'iniciarSesionEmailPassw';
  const IniSesionEmailPassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TransDatosInicioSesion;

    return StateIniSesionEmailPassword(
      args: args,
    );
  }
}

class StateIniSesionEmailPassword extends StatefulWidget {
  final TransDatosInicioSesion args;
  const StateIniSesionEmailPassword({Key? key, required this.args})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _StateIniSesionEmailPassword(args);
}

class _StateIniSesionEmailPassword extends State<StateIniSesionEmailPassword> {
  late StreamSubscription<bool> keyboardSubscription;
  final TransDatosInicioSesion args;
  _StateIniSesionEmailPassword(this.args);

  @override
  void initState() {
    super.initState();
    emailController.text = args.email;

    //Controlar la visibilidad del teclado
    var keyboardVisibilityController = KeyboardVisibilityController();
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) async {
      if (visible) {
        _cambiarH(10, 40);
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      _cambiarH(150, 80);
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  var emailController = TextEditingController();
  var passwdController = TextEditingController();
  var iconPassw = Icon(Icons.visibility);
  var passwOculta = true;

  var paddingTopAppName = 80.0;
  var paddingBottonAppName = 130.0;
  void _cambiarH(double paddingBottonAppName, double paddingTopAppName) {
    setState(() {
      this.paddingTopAppName = paddingTopAppName;
      this.paddingBottonAppName = paddingBottonAppName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            await Future.delayed(const Duration(milliseconds: 100));
            if (!mounted) return;
            Navigator.of(context).pop();
          },
        ),
        title: Text('Iniciar sesión'),
      ),
       */
      body: Padding(
        padding: EdgeInsets.only(top: paddingTopAppName, left: 40, right: 40),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: paddingBottonAppName),
              child: Text(
                'App name',
                style: GoogleFonts.roboto(
                    fontSize: 40, fontWeight: FontWeight.w600),
              ),
            ),
            args.titulo.isNotEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        args.titulo,
                        style: GoogleFonts.roboto(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : Text(''),
            SizedBox(
              height: 50,
              child: TextField(
                autofocus: false,
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                autofocus: false,
                controller: passwdController,
                obscureText: passwOculta,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => passwOculta == true
                          ? _mostrarPassw()
                          : _ocultarPassw(),
                      icon: iconPassw,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña'),
              ),
            ),
            TextButton(
                onPressed: () {}, child: Text('¿Has olvidado tu contraseña')),
            SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                    onPressed: () async {
                      await Autenticar.inciarSesionEmailPasswd(
                          emailController.text.trim(),
                          passwdController.text.trim(),
                          args.collectionReferenceUsers,
                          context);
                    },
                    child: Text(
                      'Iniciar sesion',
                      style: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ))),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TextButton(
        onPressed: () => _crearUnaCuenta(args),
        child: Text('Crear una cuenta en <App name>'),
      ),
    );
  }

  void _crearUnaCuenta(TransDatosInicioSesion arg) {
    var datos = TranferirDatosRoll('x', arg.collectionReferenceUsers);
    Navigator.pushNamed(context, Roll.ROUTE_NAME, arguments: datos);
  }

  void _mostrarPassw() {
    setState(() {
      passwOculta = false;
      iconPassw = Icon(Icons.visibility_off);
    });
  }

  void _ocultarPassw() {
    setState(() {
      passwOculta = true;
      iconPassw = Icon(Icons.visibility);
    });
  }

//Obtener credenciales con los datos especificados

}
