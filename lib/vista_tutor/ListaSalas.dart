import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/Cards.dart';

class ListaSalas {
  //Creando los parámetros que serán pasado a la siguiente pagina

  static Widget getInstance(
      BuildContext context, CollectionReference collecionUsuarios) {
    User? user = FirebaseAuth.instance.currentUser;

    String? idUserActual = user?.uid;

    //lista todas las salas que ha creado el usuario actual
    return StreamBuilder(
      stream: collecionUsuarios
          .doc(idUserActual)
          .collection('rolTutor')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Cards.vistaTutor(context, collecionUsuarios, documentSnapshot);//Devuele la vista de la sala
            },
          );
        }

        //Circulo de carga que espera hasta que se cargue el contenido
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
