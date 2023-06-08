import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../recursos/Colores.dart';
import '../../recursos/Loanding.dart';
import '../../recursos/MediaQuery.dart';
import '../../datos/TransferirDatos.dart';
import '../../recursos/AppName.dart';
import '../../recursos/Espacios.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';
import '../../MenuNavigatioBar/menu.dart';
import 'DatosNewUser.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;

  _LoginState();

  void _onLoading() {
    setState(() {
      _loading = true;
    });
  }

  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  final passw = TextEditingController();
  final correo = TextEditingController();
  final TRANSPARENT = Colors.transparent;
  String descripcion = '';
  late CollectionReference collecUsuarios;

  Color colorBorde = const Color.fromARGB(226, 114, 114, 114);

  dynamic contenidoBoton = Text(
    'Continuar con Google',
    style: GoogleFonts.roboto(
        fontSize: 19, color: Colors.black, fontWeight: FontWeight.w400),
  );

  var pLeftRight;
  var mTop;
  AppLocalizations? valores;

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    collecUsuarios = Coleciones.COLECCION_USUARIOS;
    final correo = TextEditingController();

    pLeftRight = Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    mTop = Pantalla.getPorcentPanntalla(2, context, 'y');

    var body = Container(
      padding: EdgeInsets.only(left: pLeftRight, right: pLeftRight),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _getSizedBox(15),
          getIntroduction(),
          _getSizedBox(15),
          getOptionLoggin('p', context),
          getOptionLoggin('g', context),
          //getOptionLoggin('a', context),
          //getOptionLoggin('f', context),
          _getSizedBox(10),
          //getTerms()
        ],
      ),
    );

    /*
    {
                      TranferirDatosRoll datos =
                          TranferirDatosRoll('userContraseña', collecUsuarios);
                      _irRollPage(datos);
                    }
     */

    var bodyProgress = Loanding.getLoanding(body, context);

    return Scaffold(
      body: _loading ? bodyProgress : body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _getFooter(),
    );
  }

  Widget _getSizedBox(double p) {
    return SizedBox(
      height: Pantalla.getPorcentPanntalla(p, context, 'y'),
    );
  }

  Widget getIntroduction() {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            width: Pantalla.getPorcentPanntalla(90, context, 'x'),
            child: Column(
              children: [
                Text(
                  valores?.titulo_introduccion_login as String,
                  style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(
            height: Pantalla.getPorcentPanntalla(1, context, 'y'),
          ),
          SizedBox(
            width: Pantalla.getPorcentPanntalla(70, context, 'x'),
            child: Text(
              valores?.introduccion_login as String,
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget getOptionLoggin(String option, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: mTop),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Colors.black26, width: 0.5),
      ),
      child: ListTile(
        leading: _getIcon(option),
        title: _getTitle(option, context),
        onTap: () => _invocateMethod(option),
        dense: true,
        minVerticalPadding: 0,
        visualDensity: VisualDensity.comfortable,
      ),
    );
  }

  Widget _getIcon(String option) {
    var sizeImg = Pantalla.getPorcentPanntalla(3, context, 'x');
    switch (option) {
      case 'p':
        return CircleAvatar(
          backgroundColor: TRANSPARENT,
          maxRadius: sizeImg,
          minRadius: 0,
          backgroundImage: const AssetImage('lib/recursos/imgs/img_login.png'),
        );
      case 'g':
        return CircleAvatar(
          backgroundColor: TRANSPARENT,
          maxRadius: sizeImg,
          backgroundImage: AssetImage('lib/recursos/imgs/img_google.png'),
        );
      case 'a':
        return CircleAvatar(
          backgroundColor: TRANSPARENT,
          maxRadius: sizeImg + 1,
          backgroundImage: AssetImage('lib/recursos/imgs/img_apple.png'),
        );
      default:
        return Text('');
    }
  }

  Widget _getTitle(option, BuildContext context) {
    var wordSize = 17.5;
    var styleTxt = GoogleFonts.roboto(fontSize: wordSize);

    switch (option) {
      case 'p':
        return Text(
          valores?.cont_c_email_passw as String,
          style: styleTxt,
        );
      case 'g':
        return Text(valores?.cont_c_google as String, style: styleTxt);
      case 'a':
        return Text(valores?.cont_c_apple as String, style: styleTxt);
      case 'f':
        return Text('      Continuar con Facebook', style: styleTxt);
      default:
        return Text('     ha ocurrido un herror', style: styleTxt);
    }
  }

  //Invocation method
  Future<void> _invocateMethod(String option) async {
    switch (option) {
      case 'p':
        _buttonPasswdEmail();
        return;
      case 'g':
        await _buttonGoogle();
        return;
      case 'a':
        return;
      case 'f':
        //_buttonFacebook();
        return;
      default:
        return;
    }
  }

  Widget getTerms() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: GoogleFonts.roboto(color: Colors.black),
          text: 'Al continuar, aceptas nuestros ',
          children: <TextSpan>[
            TextSpan(
              text: ' Terminos del servicios ',
              style: GoogleFonts.roboto(
                color: Colores.colorPrincipal,
              ),
              recognizer: TapGestureRecognizer()..onTap = _terminosDelServicio,
            ),
            const TextSpan(text: 'y confirmas haber leido la '),
            TextSpan(
                text: 'politica de privacidad.',
                style: GoogleFonts.roboto(color: Colores.colorPrincipal),
                recognizer: TapGestureRecognizer()
                  ..onTap = _politicaDePrivacidad),
          ]),
    );
  }

  Widget _getFooter() {
    return Container(
      height: Pantalla.getPorcentPanntalla(8, context, 'y'),
      //color: const Color.fromARGB(202, 217, 217, 217),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.transparent)),
            onPressed: () {
              TranferirDatosRoll datos =
                  TranferirDatosRoll('userContraseña');
              _irRollPage(datos);
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: valores?.no_cuenta,
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: '   ${valores?.registrarse}',
                    style: TextStyle(color: Colores.colorPrincipal))
              ]),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  void _terminosDelServicio() {}

  void _politicaDePrivacidad() {}

  void _cambiarEstadoBoton() {
    setState(() {
      contenidoBoton = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            color: Colors.black,
            size: 10,
          ),
          Icon(Icons.circle, color: Colors.black, size: 10),
          Icon(Icons.circle, color: Colors.black, size: 10)
        ],
      );
    });
  }

  void _irRollPage(TranferirDatosRoll datos) {
    context.router.push(RollRouter(args: datos));
  }

  //Metodos de cards
  void _buttonPasswdEmail() {
    var datos = TransDatosInicioSesion('', false, false, '');
    context.router.push(IniSesionEmailPasswordRouter(args: datos));

    /*Autenticar.comprobarNewOrOld(collecUsuarios, context)*/
  }

  Future<void> _buttonGoogle() async {
    _onLoading();
    var googleAccount = await Autenticar.getGoogleAcount();

    if (googleAccount == null) {
      _login();
      return;
    }

    var credencialGoogle =
        await Autenticar.obtenerCredencialesGoogle(googleAccount)
            .catchError((e) {
    });

    //Obtiene los método de inicio correspondiente al email pasado por parámetro.
    List<String> metodosInicioSesion =
        await Autenticar.metodoInicioSesion(googleAccount.email);

    var isNewUser = metodosInicioSesion.isEmpty;

    if (!mounted) return;

    await Autenticar.newOrOld( context, isNewUser, credencialGoogle, 'Google')
        .whenComplete(() => _login());
  }

  //Button facebook
  Future<void> _buttonFacebook() async {
    _onLoading();
    print('Continuar con facebook');
    var oaUthCredential = await Autenticar.obtenerCredencialesFacebook();
    if (oaUthCredential == null) {
      _login();
      return;
    }
    var credentialUser = await Autenticar.iniciarSesion(oaUthCredential!);
    bool isNewUser = credentialUser?.additionalUserInfo?.isNewUser as bool;

    isNewUser
        ? await credentialUser?.user?.delete()
        : null; //Si es nuevo se borra el usuario

    await Autenticar.newOrOld( context, isNewUser, oaUthCredential, 'Facebook')
        .whenComplete(() => _login());
  }
}
