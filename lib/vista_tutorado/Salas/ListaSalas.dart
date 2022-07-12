import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/Sala.dart';

class ListaSala_v_Tutorado {
  static Widget listar(
      BuildContext context, CollectionReference collecionUsuarios) {
    User? user = FirebaseAuth.instance.currentUser;
    String tutorActual = 'hr44Bc4CRqWJjFfDYMCBmu707Qq1';
    String? idUserActual = user?.uid.trim();
    List<dynamic> listaIdasSalas;


    return StreamBuilder(
        stream: collecionUsuarios
            .doc(idUserActual)
            .collection('rolTutorado')
            .doc(tutorActual)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var documentSnapShot = snapshot.data as DocumentSnapshot;

          //Tomar las snapshot necesesarias
          listaIdasSalas = documentSnapShot["salas_id"]; //Ids de las salas a las que está añadido el usuario actual

          //Recorre las lista de Ids de salas y obtiene las snap del tutor actual
          return ListView.builder(
            itemBuilder: (BuildContext, index) {
              return StreamBuilder(
                  stream: collecionUsuarios
                      .doc(tutorActual)
                      .collection('rolTutor')
                      .doc(listaIdasSalas[index])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Cargando');
                    }
                    var documentSnapShot = snapshot.data as DocumentSnapshot;
                    return Sala.vistaTutorado(
                        context, collecionUsuarios, documentSnapShot);
                  });
            },
            itemCount: listaIdasSalas.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            scrollDirection: Axis.vertical,
          );
        });
  }

}
