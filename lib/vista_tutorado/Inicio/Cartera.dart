import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/TransferirDatos.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

class Cartera extends StatefulWidget {
  static const ROUTE_NAME = 'cartera';

  const Cartera({
    Key? key,
  }) : super(key: key);

  @override
  State<Cartera> createState() => _CarteraState();
}

class _CarteraState extends State<Cartera> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as HelperCartera;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            _getTidasRecompensas(
                args.collectionReferenceUser, 'hr44Bc4CRqWJjFfDYMCBmu707Qq1')
          ],
        ),
      ),
    );
  }

  Widget _getTidasRecompensas(
      CollectionReference collectionReferenceUser, String idTutorActual) {
    return FutureBuilder(
        future: collectionReferenceUser
            .doc(CurrentUser.getIdCurrentUser())
            .collection('rolTutorado')
            .doc(idTutorActual)
            .collection('billeteraRecompensas')
            .orderBy('fehca_reclamo', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Text('data');
          } else if (snapshot.hasError) {
            return Icon(Icons.error_outline);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
