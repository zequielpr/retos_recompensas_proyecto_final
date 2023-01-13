import 'package:cloud_firestore/cloud_firestore.dart';

class Coleciones{
  static final CollectionReference COLECCION_USUARIOS = FirebaseFirestore.instance
      .collection('usuarios');
  static final CollectionReference NOTIFICACIONES = FirebaseFirestore.instance.collection('notificaciones');
}