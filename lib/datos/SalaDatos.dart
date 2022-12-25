import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaDatos{

  late final DocumentReference docSala;
  late  String nombre;

  SalaDatos(this.docSala, this.nombre); //Constructor - sala individual


  //Obtener id de la sala
  String get getIdSala => docSala.id;


  //misiones-----------------------------------------------------------------------------------------------------------
  //Devuelva la coleccion que contiene todas las misiones
  CollectionReference get getColecMisiones => docSala.collection('misiones');


  //Usuarios------------------------------------------------------------------------------------------------------------
  //Devuelve la coleccin que contiene todos los usuarios tutorados
  CollectionReference get getColecUsuariosTutorados => docSala.collection('usersTutorados');
  //Tomar nombre de usuario tutorado desde su documento personal


  //Ruletas-----------------------------------------------------------------------------------------------------------------
  //Devuelve el documento que contiene los valores de la ruleta
  CollectionReference get getColecRuletas => docSala.collection('contenidoRuleta');

  Future<void> setNombreSala() async => await docSala.get().then((value) => nombre = value['NombreSala']);

  String getNombreSala() => nombre;
}