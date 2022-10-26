import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminTutores.dart';

import '../../datos/CollecUsers.dart';

class Mision extends StatefulWidget {
  final DocumentSnapshot snap;
  const Mision({Key? key, required this.snap}) : super(key: key);

  @override
  State<Mision> createState() => _MisionState(snap);
}

class _MisionState extends State<Mision> {
  final DocumentSnapshot snap;
  _MisionState(DocumentSnapshot this.snap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(snap['nombre_mision']),
      ),
      body: Center(child:  getDatosMision(snap),),
    );
    ;
  }


  Widget getDatosMision( DocumentSnapshot documentSnapshot){
    String idTutorActual = AdminTutores.dropdownValue;
    return StreamBuilder(
      stream: CollecUser.COLECCION_USUARIOS
        .doc(idTutorActual)
        .collection('rolTutor')
        .doc(documentSnapshot['id_sala'])
        .collection('misiones')
        .doc(documentSnapshot['idMision']).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          final DocumentSnapshot? documentSnapshot =
              streamSnapshot.data;
          return Text('Recibe ${documentSnapshot!['recompensaMision']} puntos por: ${documentSnapshot['objetivoMision']}' );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
