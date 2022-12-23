//Registrarse con email y contrase
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/Rutas.gr.dart';

import '../../../MediaQuery.dart';
import '../../../datos/TransferirDatos.dart';
import '../../../datos/ValidarDatos.dart';
import '../../../recursos/Espacios.dart';
import '../Autenticacion.dart';
import 'IniciarSessionEmailPassw.dart';
import 'RecogerPassw.dart';

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
  bool btnActivo = true;
  void _cambiarColor(Color colorWarning, Color colorSubfix) {
    setState(() {
      this.colorWarning = colorWarning;
      this.colorSubfix = colorSubfix;
    });
  }

  @override
  Widget build(BuildContext context) {
    paddingRightLeft = Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y'), left: paddingRightLeft, right: paddingRightLeft),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: Pantalla.getPorcentPanntalla(4, context, 'y')),
                  child: Text(
                    'Introduce un correo eletrónico',
                    style: GoogleFonts.roboto(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              /*
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Introduce un correo electrónio válido y disponible',
                    style: GoogleFonts.roboto(
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
               */
              TextField(
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
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, size: 17, color: colorWarning),
                    Text(
                      emailController.text.isEmpty
                          ? 'Introduzca un email'
                          : 'Introduzca un email válido',
                      style: GoogleFonts.roboto(color: colorWarning),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Pantalla.getPorcentPanntalla(2, context, 'y')),
                child: SizedBox(
                    width: Pantalla.getPorcentPanntalla(50, context, 'x'),
                    height: Pantalla.getPorcentPanntalla(6, context, 'y'),
                    child: ElevatedButton(
                        onPressed: btnActivo?  () async => _continua(args): null,
                        child: Text(
                          'Continuar',
                          style: GoogleFonts.roboto(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> _continua(TrasnferirDatosNombreUser args) async {
    var email = emailController.text.trim();
    if (Validar.validarEmail(email)) {
      _cambiarColor(Colors.transparent, Colors.transparent);
      List<String> metodoInicioSesion =
          await Autenticar.metodoInicioSesion(email);
      //Si es existe un metodo de inicio de sesion, se redireje a la ruta de inicio de sesión
      if (metodoInicioSesion.isNotEmpty) {
        var datos = TransDatosInicioSesion('Ya estas registrado, inicia sesión',
            false, true, email);

        FocusScope.of(context).requestFocus(FocusNode());
        await Future.delayed(const Duration(milliseconds: 70));
        if (!mounted) return;
        context.router.push(IniSesionEmailPasswordRouter(args: datos));
        return;
      }

      args.setValor('email',
          email); //Añede el correo al objeto map creado en la ruta tutorado
      if (!mounted) return;
      context.router.push(RecogerPasswRouter(args: args));

      _cambiarColor(Colors.transparent, Colors.transparent);
      return;
    } else {
      _statusBoton(false);
      _cambiarColor(Colors.deepOrange, Colors.grey);
    }
  }


  void _statusBoton(bool status){
    setState((){
      btnActivo = status;
    });
  }
}
