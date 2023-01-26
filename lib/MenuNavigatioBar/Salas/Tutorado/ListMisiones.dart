import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../datos/TransferirDatos.dart';
import '../../../widgets/Cards.dart';
import '../Tutor/TabPages/pages/UsersTutorados/ExpulsarDeSala.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListMisionesTutorado extends StatefulWidget {
  final TransferirDatos args;
  const ListMisionesTutorado({Key? key, required this.args}) : super(key: key);

  @override
  State<ListMisionesTutorado> createState() => _ListMisionesTutoradoState(args);
}

class _ListMisionesTutoradoState extends State<ListMisionesTutorado> {
  final TransferirDatos args;
  _ListMisionesTutoradoState(this.args);
  AppLocalizations? valores;

  late String idTutor = args
      .sala.getColecMisiones.parent?.parent.parent?.parent.parent?.id as String;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(args.nombreSala),
          actions: [
            IconButton(
                onPressed: () => _salir_de_sala(args.sala.getIdSala,
                    CurrentUser.getIdCurrentUser(), idTutor),
                icon: const Icon(Icons.output))
          ],
        ),
        body: getListMisionesVistTutorado(args.sala.getColecMisiones));
    ;
  }

  //Metodo para obtener la misiones del usuario actual
  Widget getListMisionesVistTutorado(
      CollectionReference collectionReferenceMisiones) {
    return StreamBuilder(
      stream: collectionReferenceMisiones.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (streamSnapshot.data?.docs.isEmpty == true) {
          return Center(
            child: Text('${valores?.aun_no_misiones}'),
          );
        }

        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Cards.getCardMision(
                  documentSnapshot, CurrentUser.getIdCurrentUser(), context, 0, valores);
            },
          );
        }
        return const Text('');
      },
    );
  }

  void _salir_de_sala(idSala, idUsuario, idTutor) {
    var titulo = '${valores?.salir}';
    var mensaje = '${valores?.desea_salir_sala}';
    ExplusarDeSala.ExplusarUsuarioDesala(
        context, idSala, idUsuario, idTutor, titulo, mensaje);
  }
}
