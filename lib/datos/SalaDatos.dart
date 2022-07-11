import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaDatos{

  late final DocumentReference docSala;

  SalaDatos(this.docSala); //Constructor - sala individual


  //Obtener id de la sala
  String get getIdSala => docSala.id;


  //misiones-----------------------------------------------------------------------------------------------------------
  //Devuelva la coleccion que contiene todas las misiones
  CollectionReference get getColecMisiones => docSala.collection('misiones');


  //Usuarios------------------------------------------------------------------------------------------------------------
  //Devuelve la coleccin que contiene todos los usuarios tutorados
  CollectionReference get getColecUsuariosTutorados => docSala.collection('usersTutorados');
  //Tomar nombre de usuario tutorado desde su documento personal
  static Widget getNombreUsuario(CollectionReference collectionReferenceUsuarios, String idUsuario){
    return StreamBuilder(
        stream: collectionReferenceUsuarios.doc(idUsuario.trim()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data as DocumentSnapshot;
          return Text(userDocument["nombre"]);
        }
    );
  }


  //Ruletas-----------------------------------------------------------------------------------------------------------------
  //Devuelve el documento que contiene los valores de la ruleta
  CollectionReference get getColecRuletas => docSala.collection('contenidoRuleta');

}