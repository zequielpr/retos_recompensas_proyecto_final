import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/src/providers/oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Rutas.dart';
import '../../datos/TransferirDatos.dart';
import '../../main.dart';
import '../../splashScreen.dart';
import '../../vista_tutor/TabPages/TaPagesSala.dart';
import '../../vista_tutorado/Salas/ListaMisiones.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';
import 'EmailPassw/IniciarSessionEmailPassw.dart';
import 'EmailPassw/RecogerEmail.dart';
import 'EmailPassw/RecogerPassw.dart';
import 'login.dart';

class NombreUsuario extends StatelessWidget {
  const NombreUsuario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TrasnferirDatosNombreUser;

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
  initState() {
    super.initState();
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
    userNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: userNameController.text.length));

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
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Nombre de usuario',
                    style: GoogleFonts.roboto(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: TextField(
                    autofocus: true,
                    controller: userNameController,
                    onChanged: (usuario) {
                      _esperar(usuario, args);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nombre de usuario",
                        suffixIcon: estadoUsuario),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 200,
                  height: 42,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: botonActivo == true
                            ? MaterialStateProperty.all(Colors.blue)
                            : MaterialStateProperty.all(Colors.grey)),
                    onPressed: botonActivo == true
                        ? () async => _registrarUsuario(args)
                        : () {
                            print("Boton no activo");
                          },
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
    setState(() {
      botonActivo = false;
    });
    args.setUserName(userName);
    contador = 0;
    timer.cancel();
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
    print('dato: $tipoDato');
    if (args.oaUthCredential.runtimeType != OAuthCredential) {
      //En este caso el el atributo oaUthCredebtial continiene un hash map con la clave y la contrasela para realizar el registro
      //Registrarse con email y contreña
      await Autenticar.registrarConEmailPassw(args.oaUthCredential)
          .then((userCredential) async => {
                currentUser = userCredential?.user,
                if (currentUser != null)
                  {
                    await args.collectionReferenceUsers
                        .doc(currentUser?.uid)
                        .set({
                      "nombre_usuario": userNameController.text.trim(),
                      "rol_tutorado":
                          args.dropdownValue == "Tutor" ? false : true,
                      'nombre': args.userName
                    }),
                    Token.guardarToken(),

                    datos = TransferirDatosInicio(
                        args.dropdownValue == "Tutor" ? false : true),
                    Navigator.pushReplacementNamed(
                        context, Inicio.ROUTE_NAME,
                        arguments: datos)
                  }
              });
    } else {
      await Autenticar.iniciarSesion(args.oaUthCredential)
          .then((userCredential) async => {
                currentUser = userCredential?.user,
                if (currentUser != null)
                  {
                    await args.collectionReferenceUsers
                        .doc(currentUser?.uid)
                        .set({
                      "nombre_usuario": userNameController.text.trim(),
                      "rol_tutorado":
                          args.dropdownValue == "Tutor" ? false : true,
                      'nombre': FirebaseAuth.instance.currentUser?.displayName
                    }),
                    Token.guardarToken(),

                    datos = TransferirDatosInicio(
                        args.dropdownValue == "Tutor" ? false : true),
                    //Dirigirse a la pantalla principal
                    Navigator.pushReplacementNamed(context, Inicio.ROUTE_NAME,
                        arguments: datos)
                  }
              });
    }
  }

  //Cambiar estado del check
  void cambiarCheck(Transform check) {
    setState(() {
      estadoUsuario = check;
    });
  }
}

//Introducir roll -------------------------------------------------------------------------------------------------------
class Roll extends StatefulWidget {
  static const ROUTE_NAME = 'Roll';

  const Roll({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateRoll();
}

class _StateRoll extends State<Roll> {

  iniState(){
    super.initState();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        false); //Colores de los iconos de la barra superior
    FlutterStatusbarcolor.setStatusBarColor(Colors.white,
        animate: true);
  }

  String dropdownValue = 'Tutorado';
  @override
  Widget build(BuildContext context) {
    /*
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        false); //Colores de los iconos de la barra superior
    FlutterStatusbarcolor.setStatusBarColor(Colors.white,
        animate: true); //Color de la barra superior
     */
    final args =
        ModalRoute.of(context)!.settings.arguments as TranferirDatosRoll;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Text(
              "Registrarse",
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
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
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Selecciona un roll',
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
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
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 217),
                      child: Icon(Icons.arrow_drop_down),
                    ),
                    elevation: 1,
                    style:
                        const TextStyle(color: Colors.deepPurple, fontSize: 18),
                    underline: Container(
                      height: 2,
                      color: Colors.green,
                    ),
                    onChanged: (String? newValue) {
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
            ),
            SizedBox(
              width: 200,
              height: 42,
              child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                  onPressed: () async => _siguiente(args),
                  child: Text(
                    "Siguiente",
                    style: GoogleFonts.roboto(
                        fontSize: 16, fontWeight: FontWeight.w700),
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
    print("Nombre de usuario: ${userName}");
    var creden = args.oaUthCredential;
    print('tipo de credencial: $creden');

    if (args.oaUthCredential.runtimeType == String) {
      var datos = TrasnferirDatosNombreUser({'email': '', 'passw': ''},
          dropdownValue, userName, args.collectionReferenceUsers);
      if (!mounted) return;
      Navigator.pushNamed(context, RecogerEmail.ROUTE_NAME, arguments: datos);
    } else {
      var datos = TrasnferirDatosNombreUser(args.oaUthCredential, dropdownValue,
          userName, args.collectionReferenceUsers);
      if (!mounted) return;
      Navigator.pushNamed(context, StateNombreUsuario.ROUTE_NAME,
          arguments: datos);
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
