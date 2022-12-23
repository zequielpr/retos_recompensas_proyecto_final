import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/src/providers/oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/ValidarDatos.dart';

import '../../Rutas.dart';
import '../../datos/TransferirDatos.dart';
import '../../datos/UsuarioActual.dart';
import '../../main.dart';
import '../../recursos/Espacios.dart';
import '../../splashScreen.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';
import 'EmailPassw/IniciarSessionEmailPassw.dart';
import 'EmailPassw/RecogerEmail.dart';
import 'EmailPassw/RecogerPassw.dart';
import 'NombreUsuario.dart';
import 'login.dart';

class NombreUsuario extends StatelessWidget {
  final TrasnferirDatosNombreUser args;
  const NombreUsuario({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateNombreUsuario(
      args: args,
    );
  }
}

class StateNombreUsuario extends StatefulWidget {
  static const ROUTE_NAME = 'NombreUsuario';
  final TrasnferirDatosNombreUser args;
  const StateNombreUsuario({Key? key, required this.args}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StateNombreUsuario(args);
}

class _StateNombreUsuario extends State<StateNombreUsuario> {
  final TrasnferirDatosNombreUser args;
  _StateNombreUsuario(this.args);

  //Inicia el text field con el nombre de usuario generado en la ruta roll
  @override
  initState() {
    textField = NombreUsuarioWidget(setState, context, args, true);
    super.initState();
    /* userNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: userNameController.text.length));*/
  }

  late NombreUsuarioWidget textField;
  var paddingLeftRight;

  @override
  Widget build(BuildContext context) {
    paddingLeftRight =
        Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    //Coloca el cursor al final del texto

    return Scaffold(
        appBar: AppBar(
          title: Text('Registrarse'),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y'),
              left: paddingLeftRight,
              right: paddingLeftRight),
          child: textField.textFielNombreUsuario(context),
        ));

    throw UnimplementedError();
  }
}

//Introducir roll -------------------------------------------------------------------------------------------------------
class Roll extends StatefulWidget {
  static const ROUTE_NAME = 'Roll';
  final TranferirDatosRoll args;

  const Roll({Key? key, required this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateRoll(args);
}

class _StateRoll extends State<Roll> {
  String dropdownValue = 'Tutorado';
  final TranferirDatosRoll args;
  _StateRoll(this.args);
  var paddingRightLeft;
  @override
  Widget build(BuildContext context) {
    paddingRightLeft =
        Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    /*
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        false); //Colores de los iconos de la barra superior
    FlutterStatusbarcolor.setStatusBarColor(Colors.white,
        animate: true); //Color de la barra superior
     */
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: const [
            Text(
              "Registrarse",
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 100),
              child: Text(
                  "Selecciona el roll que deseas desepeñar. Luego podrás cambiarlo lugo", style: TextStyle(fontSize: 16),),
            ),
             */
            Padding(
              padding: EdgeInsets.only(
                  left: paddingRightLeft, right: paddingRightLeft),
              child: Column(
                children: [
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: Pantalla.getPorcentPanntalla(2, context, 'y'),
                      ),
                      child: Text(
                        'Selecciona un roll para continuar',
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Roll seleccionado: ',
                          style: TextStyle(fontSize: 20)),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Padding(
                          padding: EdgeInsets.only(
                              left: Pantalla.getPorcentPanntalla(
                                  2, context, 'x')),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        elevation: 1,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                        underline: Container(
                          height: 1.5,
                          color: Colors.grey,
                        ),
                        onChanged: (String? newValue) {
                          if (!mounted) return;
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['Tutorado', 'Tutor']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Pantalla.getPorcentPanntalla(2, context, 'y')),
              child: SizedBox(
                width: Pantalla.getPorcentPanntalla(40, context, 'x'),
                height: Pantalla.getPorcentPanntalla(6, context, 'y'),
                child: ElevatedButton(
                  onPressed: () async => _siguiente(args),
                  child: const Text(
                    "Siguiente",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

  Future<void> _siguiente(TranferirDatosRoll args) async {
    String userName = await generarUserName(args.collectionReferenceUsers);
    var creden = args.oaUthCredential;

    if (args.oaUthCredential.runtimeType == String) {
      var datos = TrasnferirDatosNombreUser({'email': '', 'passw': ''},
          dropdownValue, userName, args.collectionReferenceUsers);
      if (!mounted) return;
      context.router.push(RecogerEmailRouter(args: datos));
    } else {
      var datos = TrasnferirDatosNombreUser(args.oaUthCredential, dropdownValue,
          userName, args.collectionReferenceUsers);
      if (!mounted) return;
      context.router.push(NombreUsuarioRouter(args: datos));
    }
  }

  //Metodos
  static Future<String> generarUserName(
      CollectionReference collectionReferenceUsers) async {
    String userName = "";
    Random random = Random();

    bool userNameValido = false;

    do {
      //Generar nombre de usuario
      while (userName.length < 10) {
        userName += String.fromCharCode(random.nextInt(26) + 97);
      }
      userName += random.nextInt(10).toString();

      //Validar nombre de usuario
      await collectionReferenceUsers
          .where("nombre_usuario", isEqualTo: userName)
          .get()
          .then((value) => {
                if (value.docs.isEmpty)
                  {
                    print("nombre de usuario disponible"),
                    userNameValido = true,
                  }
                else
                  {print("Nombre de usuario no disponible"), userName = ""}
              });
    } while (userNameValido == false);

    return userName;
  }
}
