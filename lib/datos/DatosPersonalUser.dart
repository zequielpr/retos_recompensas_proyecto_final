import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

class DatosPersonales {
  ///Datos personales del usuario con el id pasado por parámetro. Devuelve el valor correspondiente a la key pasada por parámetro
  static Widget getDato(String idUser, String key) {
    return FutureBuilder<DocumentSnapshot>(
      future: CollecUser.COLECCION_USUARIOS.doc(idUser).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

  ///Devuelve el avatar del usuario con el id especificado. El tamaño del avatar será el pasado por parámetro
  static Widget getAvatar(String idUser, double size) {
    return FutureBuilder<DocumentSnapshot>(
      future: CollecUser.COLECCION_USUARIOS.doc(idUser).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return CircleAvatar(
            maxRadius: size,
            backgroundImage: NetworkImage(data['imgPerfil']),
          );
        }

        return Text("loading");
      },
    );
  }

  static Widget getIndicadoAvance(String id_user_tutorado,
      CollectionReference collectionReferenceUsers, String idTutor) {
    try{
      return StreamBuilder(
          stream: collectionReferenceUsers
              .doc(id_user_tutorado)
              .collection('rolTutorado')
              .doc(idTutor)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Loading");
            }
            var userDocument = snapshot.data as DocumentSnapshot;
            return LinearPercentIndicator(
              linearGradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xff03045E),
                  Color(0xff023E8A),
                  Color(0xff0077B6),
                  Color(0xff0096C7),
                  Color(0xff00B4D8),
                  Color(0xff48CAE4),
                  Color(0xff90E0EF),
                  Color(0xffADE8F4),
                ], // Gradient from https://learnui.design/tools/gradient-generator.html
              ),

              animation: true,
              lineHeight: 20.0,
              animateFromLastPercent: true,
              animationDuration: 1500,
              percent: userDocument['puntosTotal'] / 200,
              center: Text(userDocument['puntosTotal'].toString()),
              barRadius: Radius.circular(5),
              //progressColor: Colors.amber,
            );
          });
    }catch(e){
      return Center(child: Text('hola'),);
    }
  }
}
