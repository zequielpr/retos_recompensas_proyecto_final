import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../datos/TransferirDatos.dart';
import '../../../widgets/Cards.dart';

class ListMisionesTutorado extends StatefulWidget {
  final TransferirDatos args;
  const ListMisionesTutorado({Key? key, required this.args}) : super(key: key);

  @override
  State<ListMisionesTutorado> createState() => _ListMisionesTutoradoState(args);
}

class _ListMisionesTutoradoState extends State<ListMisionesTutorado> {
  final TransferirDatos args;
  _ListMisionesTutoradoState(this.args);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(Icons.add_box_outlined, color: Colors.transparent,),
            ),
          ],
          title: Align(
            alignment: Alignment.center,
            child: Text(args.nombreSala),
          ),
        ),
        body: getListMisionesVistTutorado(args.sala.getColecMisiones));
    ;
  }

  //Metodo para obtener la misiones del usuario actual
  static Widget getListMisionesVistTutorado(
      CollectionReference collectionReferenceMisiones) {
    return StreamBuilder(
      stream: collectionReferenceMisiones.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Cards.getCardMision(
                  documentSnapshot['nombreMision'],
                  documentSnapshot['objetivoMision'],
                  documentSnapshot['completada_por'],
                  documentSnapshot['solicitu_confirmacion'],
                  CurrentUser.getIdCurrentUser(),
                  context,
                  documentSnapshot.reference,
                  documentSnapshot['recompensaMision'],
                  0);
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
