//Registrarse con email y contrase
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../datos/TransferirDatos.dart';
import '../../../datos/ValidarDatos.dart';
import '../Autenticacion.dart';
import 'IniciarSessionEmailPassw.dart';
import 'RecogerPassw.dart';

class RecogerEmail extends StatefulWidget {
  static const ROUTE_NAME = 'RecogerEmail';
  const RecogerEmail({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecogerEmail();
}

class _RecogerEmail extends State<RecogerEmail> {
  var emailController = TextEditingController();
  var colorWarning = Colors.transparent;
  var colorSubfix = Colors.transparent;

  void _cambiarColor(Color colorWarning, Color colorSubfix) {
    setState(() {
      this.colorWarning = colorWarning;
      this.colorSubfix = colorSubfix;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TrasnferirDatosNombreUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25),
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
              SizedBox(
                height: 70,
                child: TextField(
                  autofocus: true,
                  maxLength: 60,
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
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                    width: 200,
                    height: 42,
                    child: ElevatedButton(
                        onPressed: () async => _continua(args),
                        child: Text(
                          'Continuar',
                          style: GoogleFonts.roboto(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ))),
              )
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
            false, true, email, args.collectionReferenceUsers);
        if (!mounted) return;
        Navigator.pushNamed(context, IniSesionEmailPassword.ROUTE_NAME,
            arguments: datos);
        return;
      }

      args.setValor('email',
          email); //Añede el correo al objeto map creado en la ruta tutorado
      if (!mounted) return;
      Navigator.pushNamed(context, RecogerPassw.ROUTE_NAME, arguments: args);

      _cambiarColor(Colors.transparent, Colors.transparent);
      return;
    } else {
      _cambiarColor(Colors.deepOrange, Colors.grey);
    }
  }
}
