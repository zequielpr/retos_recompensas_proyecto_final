import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/DatosNewUser.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/TransferirDatos.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../datos/UsuarioActual.dart';
import '../../../datos/ValidarDatos.dart';
import '../Autenticacion.dart';

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
        _cambiarPadding(10, 40);
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      _cambiarPadding(150, 80);
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

  var isBtnActivo = false;
  var isBtnOjoVisible = false;
  bool isPasswordIncorrect = false;
  bool elusuarioNoExiste = false;

  var paddingTopAppName = 80.0;
  var paddingBottonAppName = 130.0;
  void _cambiarPadding(double paddingBottonAppName, double paddingTopAppName) {
    setState(() {
      this.paddingTopAppName = paddingTopAppName;
      this.paddingBottonAppName = paddingBottonAppName;
    });
  }

  void _ActionCrearUnaCuenta(TransDatosInicioSesion arg) {
    var datos = TranferirDatosRoll('x', CollecUser.COLECCION_USUARIOS);
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

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.only(top: paddingTopAppName, left: Pantalla.getPorcentPanntalla(5, context, 'x'), right: Pantalla.getPorcentPanntalla(5, context, 'x')),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TextButton(
        onPressed: () => _ActionCrearUnaCuenta(args),
        child: Text('Crear una cuenta en <App name>'),
      ),
    );
  }

  //Metodos constructores de widgetd
  Widget _getAppName() {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottonAppName),
      child: Text(
        'App name',
        style: GoogleFonts.roboto(fontSize: 40, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _getIntentoRegistrarse() {
    return args.titulo.isNotEmpty
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
        : Text('');
  }

  Widget _getTextFielCorreo() {
    return Column(
      children: [
        TextField(
          autocorrect: args.focusEmail,
          onEditingComplete: () {
            print('holaa');
          },
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
          decoration: const InputDecoration(
              hintText: 'ejemplo@gmail.com',
              border: OutlineInputBorder(),
              labelText: 'Email'),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: elusuarioNoExiste == true ? Text('Usuario incorrecto', style: TextStyle(fontSize: 14, color: Colors.red), ) : SizedBox(),
        )
      ],
    );
  }

  Widget _getTextFieldPassw() {


    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        TextField(
          keyboardType: TextInputType.visiblePassword,
          autofocus: args.focusPassw,
          onChanged: (passw) {
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
                onPressed: () =>
                passwOculta == true ? _mostrarPassw() : _ocultarPassw(),
                icon: iconPassw,
              )
                  : null,
              hintText: 'escribe tu contraseña',
              labelText: 'Contraseña'),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: isPasswordIncorrect == true ? Text('Contraseña incorrecta', style: TextStyle(fontSize: 14, color: Colors.red), ) : SizedBox(),
        )],),
    );
  }

  Widget _getBtnOlvPassw() {
    return TextButton(
        onPressed: () {
          context.router.push(RecoveryPassw());
        },
        child: Text('¿Has olvidado tu contraseña'));
  }

  Widget _getBtnIniciarSesion() {
    return SizedBox(
        width: 200,
        height: 40,
        child: ElevatedButton(
            onPressed: isBtnActivo
                ? () async {
                    String resultado = await Autenticar.inciarSesionEmailPasswd(
                        emailController.text.trim(),
                        passwdController.text.trim(),
                        CollecUser.COLECCION_USUARIOS,
                        context);
                    if (resultado != 's') _indicarDatoErroneo(resultado);
                  }
                : null,
            child: Text(
              'Iniciar sesion',
            )));
  }

  void _indicarDatoErroneo(String dato) {
    if(dato == 'env'){
      var datos = TransDatosInicioSesion('', false, true, CurrentUser.currentUser != null?CurrentUser.currentUser?.email as String:'');
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
