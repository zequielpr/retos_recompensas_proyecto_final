import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatosPersonales{
  ///Datos personales del usuario con el id pasado por parámetro. Devuelve el valor correspondiente a la key pasada por parámetro
  static Widget getDato(CollectionReference collectionReferenceUser, String idUser, String key){
    return FutureBuilder<DocumentSnapshot>(
      future: collectionReferenceUser.doc(idUser).get(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return Text(data[key]);
        }

        return Text("loading");
      },
    );
  }
}