import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../datos/Roll_Data.dart';

class AdminTutores {
  static var dropdownValue;
  static Future setCurrentUser(initCurrenntTutor) async {
    CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .snapshots()
        .listen((event) {
      initCurrenntTutor(event['current_tutor']);
      dropdownValue = event['current_tutor'];
    });
  }



  @override
  static Widget listTutores(BuildContext context, actiualizarVista) {
    return FutureBuilder<QuerySnapshot>(
      future: CollecUser.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutorado')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var listaRecompensa = <String>[];

          snapshot.data?.docs.forEach((element) {
            listaRecompensa.add(element.id);
          });

          return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Text('El tutor actual es ', style: TextStyle(fontSize: 20)),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(Icons.arrow_drop_down),
              ),
              elevation: 1,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
              underline: Container(
                height: 0,
              ),
              onChanged: (newValor) {
                chanTutor(newValor!, actiualizarVista);
              },
              items: listaRecompensa
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: DatosPersonales.getDato(CollecUser.COLECCION_USUARIOS, value, 'nombre_usuario'),
                );
              }).toList(),
            )
          ]);
          ;
        }
        return Text("loading");
      },
    );
  }


  static chanTutor(String newActualTutor, actiualizarVista) async {
   await CollecUser.COLECCION_USUARIOS.doc(CurrentUser.getIdCurrentUser()).update(
        {'current_tutor':newActualTutor}).then((value) => actiualizarVista());
  }
}
