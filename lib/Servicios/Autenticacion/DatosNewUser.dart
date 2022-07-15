import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/src/providers/oauth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';


class NombreUsuario extends StatefulWidget {
  final OAuthCredential userCredential;
  final String dropdownValue;
  final String userName;
  final CollectionReference collectionReferenceUsers;
  final String metodoDeInicio;
  const NombreUsuario(this.userCredential, this.dropdownValue,
      this.userName, this.collectionReferenceUsers, this.metodoDeInicio,
      {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _StateNombreUsuario(
      userCredential, dropdownValue, userName, collectionReferenceUsers, metodoDeInicio);
}

class _StateNombreUsuario extends State<NombreUsuario> {
  final OAuthCredential oaUthCredential;
  final String dropdownValue;
  final String userName;
  final CollectionReference collectionReferenceUsers;
  final String metodoDeinicio;
  _StateNombreUsuario(this.oaUthCredential, this.dropdownValue, this.userName,
      this.collectionReferenceUsers, this.metodoDeinicio);

  void initState() {
    super.initState();
    textController.text = userName;
  }

  late User? currentUser;
  var textController = TextEditingController();
  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  late int contador;
  bool botonActivo = true;
  var estadoUsuario = Transform.scale(
      scale: 0.9,
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ));

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
    scale: 0.4,
    child: const CircularProgressIndicator(
      color: Colors.grey,
      strokeWidth: 5,
    ),
  );

  /*
  CircularProgressIndicator(
      color: Colors.grey,
      strokeWidth: 5,
    ),
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 150),
              child: TextField(
                controller: textController,
                onChanged: (usuario) {
                  contador = 0;
                  timer.cancel();
                  timer = Timer.periodic(Duration(seconds: 1), (timer) async {
                    contador++;
                    cambiarCheck(espera);
                    if (contador >= 2) {
                      await Autenticar.comprUserName(
                              usuario, collectionReferenceUsers)
                          .then((resultado) => {
                                if (resultado)
                                  {botonActivo = true, cambiarCheck(disponible)}
                                else
                                  {
                                    botonActivo = false,
                                    cambiarCheck(noDisponible)
                                  }
                              });

                      contador = 0;
                      timer.cancel();
                      print("Debe comprobarse el nombre de usuario");
                    }
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nombre de usuario",
                    suffixIcon: estadoUsuario),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: ElevatedButton(
                onPressed: botonActivo == true
                    ?  () async => _registrarUsuario()
                    : () {
                        print("Boton no activo");
                      },
                child: const Text("Registrarme"),
              ),
            )
          ],
        ));

    throw UnimplementedError();
  }

  //Registra al usuario con google y guarda sus dato
  Future<void> _registrarUsuario() async {

    await Autenticar.iniciarSesion(oaUthCredential)
        .then((userCredential) async => {
      currentUser = userCredential?.user,
      if (currentUser != null)
        {
          await collectionReferenceUsers.doc(currentUser?.uid).set({
            "nombre_usuario": textController.text.trim(),
            "rol_tutorado": dropdownValue == "Tutor" ? false : true,
            'nombre': FirebaseAuth.instance.currentUser?.displayName
          }),
          Token.guardarToken(),

          //Dirigirse a la pantalla principal
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Inicio(dropdownValue == "Tutor" ? false : true)))
        }
    });

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
  final OAuthCredential userCredential;
  final CollectionReference collectionReferenceUsers;
  final String metodoInicio;
  const Roll(this.userCredential, this.collectionReferenceUsers, this.metodoInicio,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _StateRoll(userCredential, collectionReferenceUsers, metodoInicio);
}

class _StateRoll extends State<Roll> {
  final OAuthCredential userCredential;
  final CollectionReference collectionReferenceUsers;
  final String metodoDeInicio;
  _StateRoll(this.userCredential, this.collectionReferenceUsers, this.metodoDeInicio);
  String dropdownValue = 'Tutorado';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Selecciona un roll")],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
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
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Padding(
                  padding: EdgeInsets.only(left: 217),
                  child: Icon(Icons.arrow_drop_down),
                ),
                elevation: 1,
                style: const TextStyle(color: Colors.deepPurple, fontSize: 18),
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
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  String userName =
                      await generarUserName(collectionReferenceUsers);
                  print("Nombre de usuario: ${userName}");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NombreUsuario(
                              userCredential,
                              dropdownValue,
                              userName,
                              collectionReferenceUsers, metodoDeInicio)));
                },
                child: Text("Siguiente"))
          ],
        ),
      ),
    );
    throw UnimplementedError();
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
