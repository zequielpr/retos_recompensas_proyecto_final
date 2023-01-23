//Recoger contraseña
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/DatosNewUser.dart';
import 'package:retos_proyecto/datos/ValidarDatos.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';

import '../../../datos/TransferirDatos.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecogerPassw extends StatefulWidget {
  final TrasnferirDatosNombreUser args;
  const RecogerPassw({Key? key, required this.args}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecogerPassw(args);
}

class _RecogerPassw extends State<RecogerPassw> {
  final TrasnferirDatosNombreUser args;
  _RecogerPassw(this.args);
  var passwController = TextEditingController();
  var botoActivado = false;
  var cumpleLongitud = false;
  var longValid = false;
  var letraNumValid = false;
  AppLocalizations? valores;

  var iconPassw = Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
  var passwOculta = true;
  Icon iconoLogitud = const Icon(
    Icons.circle_outlined,
    size: 20,
    color: Colors.grey,
  );
  Icon iconoLetrasN = Icon(
    Icons.circle_outlined,
    size: 20,
    color: Colors.grey,
  );
  var paddinLeftRight;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    paddinLeftRight = Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    return Scaffold(
      appBar: AppBar(
        title: Text(valores?.registrarse as String),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y'), left: paddinLeftRight, right: paddinLeftRight),
          child: getTextFieldPasswd(),
        ),
      ),
    );
  }

  Widget getTextFieldPasswd(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: Pantalla.getPorcentPanntalla(4, context, 'y')),
            child: Text(valores?.establece_passw as String,
              style: GoogleFonts.roboto(
                  fontSize: 25, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        TextField(
          keyboardType: TextInputType.visiblePassword,
          onChanged: (passw) {
            passw.length >= 8?
            passw.length <=16? _checkLongitud(true):_checkLongitud(false)
                : _checkLongitud(false);
            Validar.validarPassw(passw) == true
                ? _checkLetrasNumb(true)
                : _checkLetrasNumb(false);
          },
          obscureText: passwOculta,
          autofocus: true,
          controller: passwController,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () => passwOculta == true
                    ? _mostrarPassw()
                    : _ocultarPassw(),
                icon: iconPassw,
              ),
              border: OutlineInputBorder(),
              labelText: valores?.passw),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              iconoLogitud,
              Text(valores?.requisito_1_passw as String,
                style: GoogleFonts.roboto(fontSize: 15),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              iconoLetrasN,
              Text(valores?.requisito_2_passw as String,
                  style: GoogleFonts.roboto(fontSize: 15))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top:  Pantalla.getPorcentPanntalla(2, context, 'y')),
          child: SizedBox(
              width: Pantalla.getPorcentPanntalla(50, context, 'x'),
              height: Pantalla.getPorcentPanntalla(6, context, 'y'),
              child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0)),
                  onPressed: botoActivado
                      ? () => _continuar(args, passwController.text)
                      : null,
                  child: Text(valores?.boton_next_p_1 as String,
                    style: GoogleFonts.roboto(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ))),
        ),
      ],
    );
  }

  void _mostrarPassw() {
    setState(() {
      passwOculta = false;
      iconPassw = Icon(
        Icons.visibility,
        color: Colors.grey,
      );
    });
  }

  void _ocultarPassw() {
    setState(() {
      passwOculta = true;
      iconPassw = Icon(
        Icons.visibility_off,
        color: Colors.grey,
      );
    });
  }

  void _checkLongitud(bool isValid) {
    setState(() {
      if (isValid) {
        iconoLogitud = Icon(
          Icons.check_circle,
          size: 20,
          color: Colors.green,
        );
        longValid = true;
        return;
      }
      longValid = false;
      iconoLogitud = Icon(
        Icons.circle_outlined,
        size: 20,
        color: Colors.grey,
      );
      ;
    });
  }

  void _checkLetrasNumb(bool isValid) {
    setState(() {
      if (isValid) {
        iconoLetrasN = const Icon(
          Icons.check_circle,
          size: 20,
          color: Colors.green,
        );
        if (longValid) {
          botoActivado = true;
          return;
        }
        botoActivado = false;
        return;
      }
      botoActivado = false;
      iconoLetrasN = const Icon(
        Icons.circle_outlined,
        size: 20,
        color: Colors.grey,
      );
    });
  }

  void _continuar(TrasnferirDatosNombreUser args, passw) {
    args.setValor('passw', passw);
    context.router.push(NombreUsuarioRouter(args: args));
  }
}
