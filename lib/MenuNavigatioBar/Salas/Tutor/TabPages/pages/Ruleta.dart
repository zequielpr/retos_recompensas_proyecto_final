import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



//Aun falta por completar la ruleta 
class Ruleta extends StatelessWidget {
  final CollectionReference collectionReferenceRuleta;
  const Ruleta({Key? key, required this.collectionReferenceRuleta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    return Scaffold(
      body: Center(
          child: StreamBuilder(
            stream: collectionReferenceRuleta.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                    return
                      Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child:
                      FlatButton(
                          color: Colors.transparent,
                          splashColor: Colors.black26,
                          onPressed: () {
                          },
                          child:Column( children: [
                            Text(documentSnapshot['tipo']),

                            leerMap(documentSnapshot['contenido'])



                          ],)
                      ),);
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
      ),
    );
  }

  //Leer coleccion del contenido de las cajas
  Widget leerMap(LinkedHashMap<String, dynamic>  mapContenidoRuleta) {

    return Text('data');
  }
}
