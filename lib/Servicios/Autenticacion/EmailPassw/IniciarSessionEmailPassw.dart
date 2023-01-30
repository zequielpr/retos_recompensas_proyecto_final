import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/DatosNewUser.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/TransferirDatos.dart';

import '../../../Loanding.dart';
import '../../../datos/Roll_Data.dart';
import '../../../datos/UsuarioActual.dart';
import '../../../datos/ValidarDatos.dart';
import '../../../recursos/AppName.dart';
import '../../../recursos/Espacios.dart';
import '../Autenticacion.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IniSesionEmailPassword extends StatelessWidget {
  final TransDatosInicioSesion args;
  static const ROUTE_NAME = 'iniciarSesionEmailPassw';
  const IniSesionEmailPassword({Key? key, required this.args})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
  final TransDatosInicioSesion args;
  _StateIniSesionEmailPassword(this.args);

  @override
  void initState() {
    super.initState();

    emailController.text = args.email;
  }

  var emailController = TextEditingController();
  var passwdController = TextEditingController();
  var iconPassw = Icon(Icons.visibility);
  var passwOculta = true;

  var isBtnActivo = false;
  var isBtnOjoVisible = false;
  bool isPasswordIncorrect = false;
  bool elusuarioNoExiste = false;

  var paddingTopAppName = 80.0;
  var paddingBottonAppName = 130.0;

  void _ActionCrearUnaCuenta(TransDatosInicioSesion arg) {
    var datos = TranferirDatosRoll('x', Coleciones.COLECCION_USUARIOS);
    context.router.push(RollRouter(args: datos));
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

  void setStateBtn(bool state) {
    setState(() {
      isBtnActivo = state;
    });
  }

  void _stateBtnOjo(bool status) {
    setState(() {
      isBtnOjoVisible = status;
    });
  }

  AppLocalizations? valores;
  var body;

  var isWaiting = false;
  late Widget loanding;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    body = Container(
      margin: EdgeInsets.only(
          left: Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x'),
          right:
              Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _getAppName(),
                _getIntentoRegistrarse(),
                _getTextFielCorreo(),
                _getTextFieldPassw(),
                _getBtnOlvPassw(),
                _getBtnIniciarSesion(),
              ],
            ),
          ),
        ],
      ),
    );
    loanding = Loanding.getLoanding(body, context);
    //emailController.selection = TextSelection.fromPosition(TextPosition(offset: emailController.text.length));
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
      body: isWaiting == true ? loanding : body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TextButton(
        onPressed: () => _ActionCrearUnaCuenta(args),
        child: Text(valores?.crear_cuenta as String),
      ),
    );
  }

  //Metodos constructores de widgetd
  Widget _getAppName() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Pantalla.getPorcentPanntalla(2, context, 'y')),
      child: Text(AppName.nombre,
        style: GoogleFonts.roboto(fontSize: 40, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _getIntentoRegistrarse() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: Pantalla.getPorcentPanntalla(2, context, 'y')),
        child: Text(
          args.titulo,
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _getTextFielCorreo() {
    return Column(
      children: [
        TextField(
          autofocus: args.focusEmail,
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) {
            if (email.isNotEmpty &&
                passwdController.text.isNotEmpty &&
                Validar.validarEmail(email.trim())) {
              setStateBtn(true);
              return;
            }
            setStateBtn(false);
          },
          controller: emailController,
          decoration: InputDecoration(
              hintText: '${valores?.ejemplo }@gmail.com',
              border: OutlineInputBorder(),
              labelText: 'Email'),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: elusuarioNoExiste == true
              ? Text(valores?.email_incorrecto as String,
                  style: TextStyle(fontSize: 14, color: Colors.red),
                )
              : SizedBox(),
        )
      ],
    );
  }

  Widget _getTextFieldPassw() {
    return Padding(
      padding:
          EdgeInsets.only(top: Pantalla.getPorcentPanntalla(4, context, 'y')),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.visiblePassword,
            autofocus: args.focusPassw,
            onChanged: (passw) {
              print(passw);
              passw.isNotEmpty ? _stateBtnOjo(true) : _stateBtnOjo(false);
              if (passw.isNotEmpty &&
                  emailController.text.isNotEmpty &&
                  Validar.validarEmail(emailController.text.trim())) {
                setStateBtn(true);
                return;
              }
              setStateBtn(false);
            },
            controller: passwdController,
            obscureText: passwOculta,
            decoration: InputDecoration(
                suffixIcon: isBtnOjoVisible
                    ? IconButton(
                        onPressed: () => passwOculta == true
                            ? _mostrarPassw()
                            : _ocultarPassw(),
                        icon: iconPassw,
                      )
                    : null,
                hintText: valores?.escribe_passw,
                labelText: valores?.passw),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: isPasswordIncorrect == true
                ? Text(valores?.passw_incorrecta as String,
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  )
                : SizedBox(),
          )
        ],
      ),
    );
  }

  Widget _getBtnOlvPassw() {
    return TextButton(
        onPressed: () {
          context.router.push(RecoveryPassw());
        },
        child: Text(valores?.passw_olvidada as String));
  }

  Widget _getBtnIniciarSesion() {
    return SizedBox(
        width: Pantalla.getPorcentPanntalla(50, context, 'x'),
        height: Pantalla.getPorcentPanntalla(6, context, 'y'),
        child: ElevatedButton(
            onPressed: isBtnActivo
                ? () async {
                    setState(() {
                      isWaiting = true;
                    });
                    String resultado = await Autenticar.inciarSesionEmailPasswd(
                            emailController.text.trim(),
                            passwdController.text.trim(),
                            Coleciones.COLECCION_USUARIOS,
                            context)
                        .whenComplete((){
                              setState(() {
                                isWaiting = false;
                              });
                            });
                    if (resultado != 's')_indicarDatoErroneo(resultado);
                  }
                : null,
            child: Text(valores?.inicia_sesion as String,
            )));
  }

  void _indicarDatoErroneo(String dato) {
    if (dato == 'env') {
      //Email no verificado
      var datos = TransDatosInicioSesion(
          '',
          false,
          true,
          CurrentUser.currentUser != null
              ? CurrentUser.currentUser?.email as String
              : emailController.text);
      context.router.push(InfoVerificacionEmailRouter(arg: datos));
      return;
    }

    isPasswordIncorrect = false;
    elusuarioNoExiste = false;

    setState(() {
      if (dato == 'u') {
        elusuarioNoExiste = true;
        return;
      }
      isPasswordIncorrect = true;
    });
  }

//Obtener credenciales con los datos especificados

}
