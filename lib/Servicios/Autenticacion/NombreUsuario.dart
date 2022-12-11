import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

import '../../Rutas.gr.dart';
import '../../datos/TransferirDatos.dart';
import '../../datos/UsuarioActual.dart';
import '../../datos/ValidarDatos.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';

class NombreUsuarioWidget {
  static var nombreUsuarioActual;
  static var vistaModificarUserName;
  static var vistaPerfil;
  var _setState;
  late BuildContext _context;
  TrasnferirDatosNombreUser _args;
  bool _isRegistrandoUser;

  NombreUsuarioWidget(
      this._setState, this._context, this._args, this._isRegistrandoUser) {
    _userNameController.text = _args.userName;
  }

  var _userNameController = TextEditingController();
  Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  late int _contador;
  bool _botonActivo = true;
  late User? _currentUser;

  bool noMostrarAdver = true;
  var mensajeAdver;

  void _mostrarMensjae(mensaje) {
    _setState(() {
      noMostrarAdver = false;
      mensajeAdver = Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.red,
            size: 16,
          ),
          Text(
            mensaje,
            style: TextStyle(color: Colors.red, fontSize: 13),
          )
        ],
      );
    });
  }

  Widget textFielNombreUsuario() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              'Nombre de usuario',
              style:
                  GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.name,
                autofocus: true,
                controller: _userNameController,
                onChanged: (usuario) {
                  _esperar(usuario);
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Nombre de usuario",
                    suffixIcon: _estadoUsuario),
              ),
              noMostrarAdver == false ? mensajeAdver : Text('')
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: 200,
            height: 42,
            child: ElevatedButton(
              style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
              onPressed: _botonActivo
                  ? () async => _guardarNombreUsuario(_args)
                  : null,
              child: Text(_isRegistrandoUser ? "Registrarme" : 'Guardar',
                  style: GoogleFonts.roboto(
                      fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ),
        )
      ],
    );
  }

  void _guardarNombreUsuario(_args) {
    if (_isRegistrandoUser) {
      _registrarUsuario(_args);
      return;
    }
    _modificarUserName(_args.userName);
  }

  void _cambiarCheck(Transform check) {
//verifica que el widget este montado antes de actualizar su estado
    _setState(() {
      _estadoUsuario = check;
    });
  }

  void _esperar(String userName) {
    noMostrarAdver = true;
    _botonActivo = false;
    _cambiarCheck(_escribiendo);
    print('Nombre: $userName');

    _args.setUserName(userName);
    _contador = 0;
    _timer.cancel();
    if (!Validar.validarUserName(userName)) {
      //Mostrar advertencia especificando por que el nombre de usuario no es valido
      var mensaje = '3-30 caracteres, no caracteres especiales';
      _mostrarMensjae(mensaje);
      _cambiarCheck(_noDisponible);
    } else {
      _timer = Timer.periodic(Duration(milliseconds: 800), (timer) async {
        _contador++;
        if (_contador >= 2) {
          _cambiarCheck(_espera);
          await Autenticar.comprUserName(userName).then((resultado) {
            if (resultado) {
              _botonActivo = true;
              _cambiarCheck(_disponible);
            } else {
              var mensaje = 'Usuario no disponible';
              _mostrarMensjae(mensaje);
              _botonActivo = false;
              _cambiarCheck(_noDisponible);
            }
          });

          _contador = 0;
          timer.cancel();
          print("Debe comprobarse el nombre de usuario");
        }
      });
    }
  }

  var _estadoUsuario = Transform.scale(
      scale: 0.9,
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ));

  var _escribiendo = Transform.scale(
    scale: 0.9,
    child: Icon(
      Icons.circle_outlined,
      color: Colors.transparent,
    ),
  );

  var _disponible = Transform.scale(
      scale: 0.9,
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ));

  var _noDisponible = Transform.scale(
      scale: 0.9,
      child: const Icon(
        Icons.cancel,
        color: Colors.red,
      ));

  var _espera = Transform.scale(
    scale: 0.3,
    child: const CircularProgressIndicator(
      color: Colors.grey,
      strokeWidth: 5,
    ),
  );

  Future<void> _registrarUsuario(TrasnferirDatosNombreUser args) async {
    var datos;
    var medioRegistro = args.oaUthCredential.runtimeType;

    //Usuario que no se registran con google
    if (medioRegistro != GoogleAuthCredential) {
      //En este caso el el atributo oaUthCredebtial continiene un hash map con la clave y la contrasela para realizar el registro
      //Registrarse con email y contreña
      await Autenticar.registrarConEmailPassw(args.oaUthCredential)
          .then((userCredential) async => {
                _currentUser = userCredential?.user,
                if (_currentUser != null)
                  {
                    CurrentUser.setCurrentUser(),
                    await args.collectionReferenceUsers
                        .doc(_currentUser?.uid)
                        .set({
                      "current_tutor": '',
                      "nombre_usuario": _userNameController.text.trim(),
                      "rol_tutorado":
                          args.dropdownValue == "Tutor" ? false : true,
                      'nombre': args.userName,
                      'imgPerfil': _currentUser?.photoURL
                    }),
                    await args.collectionReferenceUsers
                        .doc(_currentUser?.uid)
                        .collection('notificaciones')
                        .doc(_currentUser?.uid)
                        .set({
                      'nueva_mision': false,
                      'nueva_solicitud': false,
                      'numb_misiones': 0,
                      'numb_solicitudes': 0
                    }),
                    Token.guardarToken(),
                    _context.router.replace(MainRouter())
                  }
              });
    } else {
      await Autenticar.iniciarSesion(args.oaUthCredential)
          .then((userCredential) async => {
                _currentUser = userCredential?.user,
                if (_currentUser != null)
                  {
                    CurrentUser.setCurrentUser(),
                    await args.collectionReferenceUsers
                        .doc(_currentUser?.uid)
                        .set({
                      "current_tutor": '',
                      "nombre_usuario": _userNameController.text.trim(),
                      "rol_tutorado":
                          args.dropdownValue == "Tutor" ? false : true,
                      'nombre': FirebaseAuth.instance.currentUser?.displayName,
                      'imgPerfil': _currentUser?.photoURL
                    }),
                    await args.collectionReferenceUsers
                        .doc(_currentUser?.uid)
                        .collection('notificaciones')
                        .doc(_currentUser?.uid)
                        .set({
                      'nueva_mision': false,
                      'nueva_solicitud': false,
                      'numb_misiones': 0,
                      'numb_solicitudes': 0
                    }),
                    Token.guardarToken(),

                    datos = TransferirDatosInicio(
                        args.dropdownValue == "Tutor" ? false : true),
                    //Dirigirse a la pantalla principal
                    _context.router.replace(MainRouter())
                  }
              });
    }
  }

  Future<void> _modificarUserName(String userName) async {
    bool succeful = true;
    var mensaje = 'Nombre de usuario guardado correctamente';
    await CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .update({'nombre_usuario': userName}).catchError((onError) {
      succeful = false;
      mensaje = 'El nombre de usuario no se ha guardado correctamente';
    });

    if (succeful) {
      vistaModificarUserName(() {});
      vistaPerfil(() {});
    }

    final snackBar = SnackBar(
      content: Text(mensaje),
    );
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
    _context.router.pop();
  }
}
