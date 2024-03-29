//Registrarse con email y contrase
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/recursos/Loanding.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/recursos/Valores.dart';

import '../../../recursos/MediaQuery.dart';
import '../../../datos/TransferirDatos.dart';
import '../../../datos/ValidarDatos.dart';
import '../../../recursos/Espacios.dart';
import '../Autenticacion.dart';
import 'IniciarSessionEmailPassw.dart';
import 'RecogerPassw/RecogerPassw.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecogerEmail extends StatefulWidget {
  final TrasnferirDatosNombreUser args;
  static const ROUTE_NAME = 'RecogerEmail';
  const RecogerEmail({Key? key, required this.args}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecogerEmail(args);
}

class _RecogerEmail extends State<RecogerEmail> {
  final TrasnferirDatosNombreUser args;
  _RecogerEmail(this.args);
  var emailController = TextEditingController();
  var colorWarning = Colors.transparent;
  var colorSubfix = Colors.transparent;
  var paddingRightLeft;
  var body;
  var loanding;
  bool isWaiting = false;
  bool btnActivo = true;
  AppLocalizations? valores;
  void _cambiarColor(Color colorWarning, Color colorSubfix) {
    setState(() {
      this.colorWarning = colorWarning;
      this.colorSubfix = colorSubfix;
    });
  }

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    paddingRightLeft =
        Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    body = Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y'),
            left: paddingRightLeft,
            right: paddingRightLeft),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _getTitle(),
            _getTextField(),
            _getErrorMessage(),
            _getBtnContinuar(),
          ],
        ),
      ),
    );
    loanding = Loanding.getLoanding(body, context);
    return Scaffold(
      appBar: AppBar(
        title: Text(valores?.registrarse as String),
      ),
      body: isWaiting?loanding:body,
    );
  }

  Align _getTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: Pantalla.getPorcentPanntalla(4, context, 'y')),
        child: Text(valores?.introdc_correo_electronico as String,
          style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  TextField _getTextField() {
    return TextField(
      onChanged: (value) => _statusBoton(true),
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Email',
          suffixIcon: Icon(
            Icons.error,
            color: colorSubfix,
            size: 20,
          )),
    );
  }

  Align _getErrorMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            emailController.text.isEmpty
                ? valores?.introdc_correo_electronico as String
                : valores?.introduzca_email_valido as String,
            style: GoogleFonts.roboto(color: colorWarning),
          ),
        ],
      ),
    );
  }

  Padding _getBtnContinuar() {
    return Padding(
      padding:
          EdgeInsets.only(top: Pantalla.getPorcentPanntalla(2, context, 'y')),
      child: SizedBox(
          width: Pantalla.getPorcentPanntalla(50, context, 'x'),
          height: Pantalla.getPorcentPanntalla(6, context, 'y'),
          child: ElevatedButton(
              onPressed: btnActivo ? () async => _continua(args) : null,
              child: Text(valores?.boton_next_p_1 as String,
                style: GoogleFonts.roboto(
                    fontSize: 17, fontWeight: FontWeight.w600),
              ))),
    );
  }

  Future<void> _continua(TrasnferirDatosNombreUser args) async {
    var email = emailController.text.trim();
    if (Validar.validarEmail(email)) {
      setState(() {isWaiting = true;});
      _cambiarColor(Colors.transparent, Colors.transparent);

      dynamic metodoInicioSesion = await Autenticar.metodoInicioSesion(email);

      //Si es existe un metodo de inicio de sesion, se redireje a la ruta de inicio de sesión
      if (metodoInicioSesion.isNotEmpty) {
        var datos = TransDatosInicioSesion(
            valores?.ya_estas_registrado as String, false, true, email);
        context.router.push(IniSesionEmailPasswordRouter(args: datos)).whenComplete(() => setState(() {isWaiting = false;}));
        return;
      }

      args.setValor('email', email); //Añede el correo al objeto map creado en la ruta tutorado
      if (!mounted) return;
      
      context.router.push(RecogerPasswRouter(args: args)).whenComplete(() => setState(() {isWaiting = false;}));

      _cambiarColor(Colors.transparent, Colors.transparent);
      return;
    } else {
      _statusBoton(false);
      _cambiarColor(Colors.deepOrange, Colors.grey);
    }
  }

  void _statusBoton(bool status) {
    setState(() {
      btnActivo = status;
    });
  }
}
