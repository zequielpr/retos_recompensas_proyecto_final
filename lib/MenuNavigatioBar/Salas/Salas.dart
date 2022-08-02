import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../widgets/Cards.dart';

class Salas extends StatefulWidget {
  const Salas({Key? key}) : super(key: key);

  @override
  State<Salas> createState() => _SalasState();
}

class _SalasState extends State<Salas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.person),),
        title: Align(
          alignment: Alignment.center,
          child: Text('Salas'),
        ),
        
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.add_box_outlined))],
      ),
      body: Container(
        child: Roll_Data.ROLL_USER_IS_TUTORADO
            ? _listarVistaTutorados(context, CollecUser.COLECCION_USUARIOS)
            : getVistaSalasVistaTutor(context, CollecUser.COLECCION_USUARIOS),
      ),
    );
    ;
  }

  //Vista de las salas para los tutorados
  _listarVistaTutorados(
      BuildContext context, CollectionReference collecionUsuarios) {
    String tutorActual = 'hr44Bc4CRqWJjFfDYMCBmu707Qq1';
    List<dynamic> listaIdasSalas;

    return StreamBuilder(
        stream: collecionUsuarios
            .doc(CurrentUser.getIdCurrentUser())
            .collection('rolTutorado')
            .doc(tutorActual)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var documentSnapShot = snapshot.data as DocumentSnapshot;

          //Tomar las snapshot necesesarias
          listaIdasSalas = documentSnapShot[
              "salas_id"]; //Ids de las salas a las que está añadido el usuario actual

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
                    return Cards.CardSalaVistaTutorado(
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

  static Widget getVistaSalasVistaTutor(
      BuildContext context, CollectionReference collecionUsuarios) {
    //lista todas las salas que ha creado el usuario actual
    return StreamBuilder(
      stream: collecionUsuarios
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutor')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Cards.vistaTutor(context, collecionUsuarios,
                  documentSnapshot); //Devuele la vista de la sala
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
