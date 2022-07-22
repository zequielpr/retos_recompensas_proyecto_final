import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../datos/DatosPersonalUser.dart';

class InicioTutorado extends StatefulWidget {
  final CollectionReference collectionReferenceUsers;
  const InicioTutorado({Key? key, required this.collectionReferenceUsers})
      : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _InicioTutorado(collectionReferenceUsers);
}

class _InicioTutorado extends State<InicioTutorado> {
  final CollectionReference collectionReferenceUsers;

  _InicioTutorado(this.collectionReferenceUsers);
  var idTutorActual = 'hr44Bc4CRqWJjFfDYMCBmu707Qq1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_getBarAvance(), _showCajaRecompensa()],
      ),
    );
  }

  Widget _getBarAvance() {
    return Padding(
      padding: EdgeInsets.only(top: 80, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
              flex: 6,
              child: DatosPersonales.getIndicadoAvance(
                  FirebaseAuth.instance.currentUser?.uid as String,
                  collectionReferenceUsers,
                  idTutorActual)),
          Expanded(flex: 1, child: Icon(Icons.flag)),
          Expanded(flex: 1, child: Text('200'))
        ],
      ),
    );
  }

  //Caja de recompesa
  Widget _showCajaRecompensa() {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Container(
        height: 250,
        width: 250,
        color: Colors.amber,
      ),
    );
  }
}
//DatosPersonales.getIndicadoAvance(doc)
