//Recoger contraseña
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/DatosNewUser.dart';
import 'package:retos_proyecto/datos/ValidarDatos.dart';

import '../../../datos/TransferirDatos.dart';

class RecogerPassw extends StatefulWidget {
  static const ROUTE_NAME = 'RecogerPassw';
  const RecogerPassw({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecogerPassw();
}

class _RecogerPassw extends State<RecogerPassw> {
  var passwController = TextEditingController();
  var botoActivado = false;
  var cumpleLongitud = false;
  var longValid = false;
  var letraNumValid = false;
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
                    'Establece una contraseña',
                    style: GoogleFonts.roboto(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(
                height: 65,
                child: TextField(
                  onChanged: (passw) {
                    passw.length >= 8
                        ? _checkLongitud(true)
                        : _checkLongitud(false);
                    Validar.validarPassw(passw) == true
                        ? _checkLetrasNumb(true)
                        : _checkLetrasNumb(false);
                  },
                  obscureText: passwOculta,
                  autofocus: true,
                  maxLength: 16,
                  controller: passwController,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    iconoLogitud,
                    Text(
                      'Entre 8 y 16 caracteres',
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
                    Text('Letras, numeros y caracteres especiales',
                        style: GoogleFonts.roboto(fontSize: 15))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                    width: 200,
                    height: 42,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: botoActivado
                            ? () => _continuar(args, passwController.text)
                            : null,
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
    Navigator.pushNamed(context, StateNombreUsuario.ROUTE_NAME,
        arguments: args);
  }
}
