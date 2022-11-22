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
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/ValidarDatos.dart';

import '../../Rutas.dart';
import '../../datos/TransferirDatos.dart';
import '../../datos/UsuarioActual.dart';
import '../../main.dart';
import '../../splashScreen.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';
import 'EmailPassw/IniciarSessionEmailPassw.dart';
import 'EmailPassw/RecogerEmail.dart';
import 'EmailPassw/RecogerPassw.dart';
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
    super.initState();
    userNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: userNameController.text.length));
    _esperar(args.userName, args);
    userNameController.text = args.userName;
  }

  late User? currentUser;
  var userNameController = TextEditingController();
  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  late int contador;
  bool botonActivo = true;

  var estadoUsuario = Transform.scale(
      scale: 0.9,
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ));

  var escribiendo = Transform.scale(
    scale: 0.9,
    child: Icon(
      Icons.circle_outlined,
      color: Colors.transparent,
    ),
  );

  var disponible = Transform.scale(
      scale: 0.9,
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ));

  var noDisponible = Transform.scale(
      scale: 0.9,
      child: const Icon(
        Icons.cancel,
        color: Colors.red,
      ));

  var espera = Transform.scale(
    scale: 0.3,
    child: const CircularProgressIndicator(
      color: Colors.grey,
      strokeWidth: 5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    //Coloca el cursor al final del texto

    return Scaffold(
        appBar: AppBar(
          title: Text('Registrarse'),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 40, left: 30, right: 30),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Nombre de usuario',
                    style: GoogleFonts.roboto(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  controller: userNameController,
                  onChanged: (usuario) {
                    _esperar(usuario.trim(), args);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nombre de usuario",
                      suffixIcon: estadoUsuario),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 200,
                  height: 42,
                  child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                    onPressed: botonActivo
                        ? () async => _registrarUsuario(args)
                        : null,
                    child: Text("Registrarme",
                        style: GoogleFonts.roboto(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                ),
              )
            ],
          ),
        ));

    throw UnimplementedError();
  }

  //Solo prueba
  void _prueba() {}

  //Esperear antes de comprobar
  void _esperar(String userName, TrasnferirDatosNombreUser args) {
    cambiarCheck(escribiendo);
    if (!mounted) return;
    setState(() {
      botonActivo = false;
    });

    args.setUserName(userName);
    contador = 0;
    timer.cancel();
    if (!Validar.validarUserName(userName)) {
      botonActivo = false;
      cambiarCheck(noDisponible);
      return;
    }
    timer = Timer.periodic(Duration(milliseconds: 800), (timer) async {
      contador++;
      if (contador >= 2) {
        cambiarCheck(espera);
        await Autenticar.comprUserName(userName, args.collectionReferenceUsers)
            .then((resultado) => {
                  if (resultado)
                    {botonActivo = true, cambiarCheck(disponible)}
                  else
                    {botonActivo = false, cambiarCheck(noDisponible)}
                });

        contador = 0;
        timer.cancel();
        print("Debe comprobarse el nombre de usuario");
      }
    });
  }

  //Registra al usuario con google y guarda sus dato
  Future<void> _registrarUsuario(TrasnferirDatosNombreUser args) async {
    var datos;
    var tipoDato = args.oaUthCredential.runtimeType;

    //Usuario que no se registran con google
    if (args.oaUthCredential.runtimeType != GoogleAuthCredential) {
      //En este caso el el atributo oaUthCredebtial continiene un hash map con la clave y la contrasela para realizar el registro
      //Registrarse con email y contreña
      await Autenticar.registrarConEmailPassw(args.oaUthCredential)
          .then((userCredential) async => {
                currentUser = userCredential?.user,
                if (currentUser != null)
                  {
                    CurrentUser.setCurrentUser(),
                    await args.collectionReferenceUsers
                        .doc(currentUser?.uid)
                        .set({
                      "current_tutor": '',
                      "nombre_usuario": userNameController.text.trim(),
                      "rol_tutorado":
                          args.dropdownValue == "Tutor" ? false : true,
                      'nombre': args.userName,
                      'imgPerfil': currentUser?.photoURL
                    }),

                    await args.collectionReferenceUsers
                        .doc(currentUser?.uid)
                        .collection('notificaciones')
                        .doc(currentUser?.uid)
                        .set({
                      'nueva_mision': false,
                      'nueva_solicitud': false,
                      'numb_misiones': 0,
                      'numb_solicitudes': 0
                    }),

                    Token.guardarToken(),

                    context.router.replace(MainRouter())
                  }
              });
    } else {
      await Autenticar.iniciarSesion(args.oaUthCredential)
          .then((userCredential) async => {
                currentUser = userCredential?.user,
                if (currentUser != null)
                  {
                    CurrentUser.setCurrentUser(),
                    await args.collectionReferenceUsers
                        .doc(currentUser?.uid)
                        .set({
                      "current_tutor": '',
                      "nombre_usuario": userNameController.text.trim(),
                      "rol_tutorado":
                          args.dropdownValue == "Tutor" ? false : true,
                      'nombre': FirebaseAuth.instance.currentUser?.displayName,
                      'imgPerfil': currentUser?.photoURL
                    }),
                    await args.collectionReferenceUsers
                        .doc(currentUser?.uid)
                        .collection('notificaciones')
                        .doc(currentUser?.uid)
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
                    context.router.replace(MainRouter())
                  }
              });
    }
  }

  //Cambiar estado del check
  void cambiarCheck(Transform check) {
    if (!mounted)
      return; //verifica que el widget este montado antes de actualizar su estado
    setState(() {
      estadoUsuario = check;
    });
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
  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Text(
                        'Selecciona un roll para continuar',
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  /*
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Tutor: ',
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          TextSpan(
                              text:
                                  'se encarga de añadir usuario a su tutoría y asignar tareas o misiones.',
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black))
                        ])),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Tutorado: ',
                                style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)),
                            TextSpan(
                                text:
                                    'Recibe recompensas a cambio de realizar las tareas asignadas por el tutor.',
                                style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black))
                          ])),
                    ),
                  ),
                   */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Roll seleccionado: ',
                          style: TextStyle(fontSize: 20)),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        elevation: 1,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
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
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: () async => _siguiente(args),
                  child: const Text(
                    "Siguiente",
                  )),
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
