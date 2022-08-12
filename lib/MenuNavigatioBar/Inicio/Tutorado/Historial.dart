import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

import '../../../datos/TransferirDatos.dart';
import '../../../datos/UsuarioActual.dart';

class Historial extends StatefulWidget {
  static const ROUTE_NAME = 'cartera';

  const Historial({
    Key? key,
  }) : super(key: key);

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: (){}, icon: Padding(padding: EdgeInsets.only(right:Pantalla.getPorcentPanntalla(2, context, 'x') ), child: Icon(Icons.grid_view)),)],
          title: Text('Recompensas recibidas'),
        ),
        body: _getTidasRecompensas(
            CollecUser.COLECCION_USUARIOS, 'CGWDtkvBpPSFfsziW0T3x1zfEAt1')
        //_getTidasRecompensas(
        //                 CollecUser.COLECCION_USUARIOS, 'hr44Bc4CRqWJjFfDYMCBmu707Qq1')
        );
  }

  Widget _getTidasRecompensas(
      CollectionReference collectionReferenceUser, String idTutorActual) {
    return FutureBuilder<QuerySnapshot>(
      future: collectionReferenceUser
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutorado')
          .doc(idTutorActual)
          .collection('billeteraRecompensas')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Widget> listaRecompensa = [Text('hola')];

          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            listaRecompensa
                .add(getCardRecompensa(data['titulo'], data['contenido']));
          });

          var top = Pantalla.getPorcentPanntalla(5, context, 'y');
          var left = Pantalla.getPorcentPanntalla(3, context, 'x');
          var right = Pantalla.getPorcentPanntalla(3, context, 'x');

          var ratio = Pantalla.getPorcentPanntalla(0.15, context, 'y');
          return GridView.count(
            padding: EdgeInsets.only(top: top, left: left , right: right),
            childAspectRatio: ratio ,
            crossAxisSpacing: Pantalla.getPorcentPanntalla(3, context, 'x'),
            mainAxisSpacing: Pantalla.getPorcentPanntalla(3, context, 'x'),
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return getCardRecompensa(data['titulo'], data['contenido']);
                })
                .toList()
                .cast(),
          );
          ;
        }
        return Text("loading");
      },
    );
  }

  Widget getCardRecompensa(String titulo, String contenido) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(color: Colors.black26, width: 3)),
            )),
        onPressed: () {},
        child: Container(
          width: 100,
          height: 100,
          child: Center(
              child: Text(
            titulo,
            textAlign: TextAlign.center,
          )),
        ));
  }
}
