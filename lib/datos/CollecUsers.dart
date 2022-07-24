import 'package:cloud_firestore/cloud_firestore.dart';

class CollecUser{
  static final CollectionReference COLECCION_USUARIOS = FirebaseFirestore.instance
      .collection('usuarios');
}