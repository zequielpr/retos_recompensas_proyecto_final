import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/recursos/Loanding.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';

import '../../recursos/MediaQuery.dart';
import '../../Rutas.gr.dart';
import '../../datos/TransferirDatos.dart';
import '../../datos/UsuarioActual.dart';
import '../../datos/ValidarDatos.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NombreUsuarioWidget {
  static var nombreUsuarioActual;
  static var vistaModificarUserName;
  static var vistaPerfil;
  var _setState;
  late BuildContext _context;
  TrasnferirDatosNombreUser _args;
  bool _isRegistrandoUser;
  var body;
  var loanding;
  bool isWaiting = false;
  AppLocalizations? valores;

  NombreUsuarioWidget(
      this._setState, this._context, this._args, this._isRegistrandoUser) {
    _userNameController.text = _args.userName;
    valores = valores = AppLocalizations.of(_context);
  }

  void cancelTimer(){
    _timer.cancel();
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

  Widget textFielNombreUsuario(BuildContext context) {

    body = Column(
      children: [
        _getTitle(context)
        ,
        _getTextField()
        ,
        _getBtn(context)
      ],
    );
    loanding = Loanding.getLoanding(body, context);
    return isWaiting?loanding:body;
  }
  Align _getTitle(BuildContext context){
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: Pantalla.getPorcentPanntalla(4, context, 'y')),
        child: Text(
          valores?.nombre_usuario as String,
          style:
          GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
  Column _getTextField(){
    return Column(
      children: [
        TextField(
          maxLength: 30,
          keyboardType: TextInputType.name,
          autofocus: true,
          controller: _userNameController,
          onChanged: (usuario) {
            _esperar(usuario);
          },
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: valores?.nombre_usuario as String,
              suffixIcon: _estadoUsuario),
        ),
        noMostrarAdver == false ? mensajeAdver : Text('')
      ],
    );
  }
  Padding _getBtn(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(top: Pantalla.getPorcentPanntalla(2, context, 'y')),
      child: SizedBox(
        width: Pantalla.getPorcentPanntalla(50, context, 'x'),
        height: Pantalla.getPorcentPanntalla(6, context, 'y'),
        child: ElevatedButton(
          style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
          onPressed: _botonActivo
              ? () async => _guardarNombreUsuario(_args)
              : null,
          child: Text(_isRegistrandoUser ? valores?.registrarse as String : valores?.guardar as String,
              style: GoogleFonts.roboto(
                  fontSize: 17, fontWeight: FontWeight.w600)),
        ),
      ),
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
      var mensaje = valores?.entre_3_30_caracteres_no_especiales;
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
              var mensaje = valores?.usuario_no_disponible as String;
              _mostrarMensjae(mensaje);
              _botonActivo = false;
              _cambiarCheck(_noDisponible);
            }
          });

          _contador = 0;
          timer.cancel();
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

    _setState((){isWaiting = true;});
    //Usuario que no se registran con google
    if (medioRegistro != GoogleAuthCredential) {
      //En este caso el el atributo oaUthCredebtial continiene un hash map con la clave y la contrasela para realizar el registro
      //Registrarse con email y contreña
      await Autenticar.registrarConEmailPassw(args.oaUthCredential)
          .then((userCredential) async{
                _currentUser = userCredential?.user;
                if (_currentUser != null)
                  {
                    CurrentUser.setCurrentUser();
                    CurrentUser.currentUser?.updatePhotoURL('https://firebasestorage.googleapis.com/v0/b/retosrecompensas.appspot.com/o/Imagen_anonimo.jpg?alt=media&token=b9e53ae2-d606-4a52-a7c5-4c4f146b9c89');
                    CurrentUser.currentUser?.updateDisplayName( _userNameController.text.trim());
                    await args.collectionReferenceUsers
                        .doc(_currentUser?.uid)
                        .set({
                      "current_tutor": '',
                      "nombre_usuario": _userNameController.text.trim(),
                      "rol_tutorado":
                          args.dropdownValue == "Tutor" ? false : true,
                      'nombre': args.userName,
                      'imgPerfil': 'https://firebasestorage.googleapis.com/v0/b/retosrecompensas.appspot.com/o/Imagen_anonimo.jpg?alt=media&token=b9e53ae2-d606-4a52-a7c5-4c4f146b9c89'
                    });
                    await args.collectionReferenceUsers
                        .doc(_currentUser?.uid)
                        .collection('notificaciones')
                        .doc(_currentUser?.uid)
                        .set({
                      'nueva_mision': false,
                      'nueva_solicitud': false,
                      'numb_misiones': 0,
                      'numb_solicitudes': 0
                    });
                    Token.guardarToken();
                    var datos = TransDatosInicioSesion('', false, true, CurrentUser.currentUser?.email as String);
                    await _context.router.replaceAll([InfoVerificacionEmailRouter( arg: datos)]);

                  }
              }).whenComplete(() => _setState((){isWaiting = false;}));
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
              }).whenComplete(() => _setState((){isWaiting = false;}));
    }
  }

  Future<void> _modificarUserName(String userName) async {
    bool succeful = true;
    var mensaje = valores?.nombre_actualizado_correct as String;
    await Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .update({'nombre_usuario': userName}).catchError((onError) {
      succeful = false;
      mensaje = valores?.nombre_usuario_no_guardado as String;
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
