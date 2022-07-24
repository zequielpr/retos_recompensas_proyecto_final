import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../../datos/DatosPersonalUser.dart';
import '../../../../../../datos/TransferirDatos.dart';
import '../../../../../../datos/UsuarioActual.dart';
import '../../../../../../widgets/Cards.dart';




class UserTutoradoDescrip extends StatefulWidget {
  final TransfDatosUserTutorado args;
  static const ROUTE_NAME = '/UserTutoradoDescrip';
  const UserTutoradoDescrip({Key? key, required this.args}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserTotoradoDescrip(args);
}

class _UserTotoradoDescrip extends State<UserTutoradoDescrip> {
  final TransfDatosUserTutorado args;
  _UserTotoradoDescrip(this.args);
  double _currentSliderValue = 15;
  static var puntos;

  @override
  Widget build(BuildContext context) {
    final colecTodosLosUsuarios = args.snap.reference.parent.parent?.parent
        .parent?.parent; //navega hacia la coleccion de todos los usuarios

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: DatosPersonales.getDato(colecTodosLosUsuarios!, args.snap.id, 'nombre_usuario'),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
            ],
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(200),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Center(
                              child: DatosPersonales.getAvatar(colecTodosLosUsuarios, args.snap.id.trim(), 40),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: DatosPersonales.getIndicadoAvance(args.snap.reference.id, colecTodosLosUsuarios, CurrentUser.getIdCurrentUser())
                          ),
                          Expanded(flex: 1, child: Text(''))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: DatosPersonales.getDato(colecTodosLosUsuarios, args.snap.id.trim(), 'nombre'),
                        )
                      ],
                    ),
                    const TabBar(
                      labelColor: Colors.black,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.flag,
                            color: Colors.black,
                          ),
                          text: 'misiones',
                        ),
                        Tab(
                          icon: Icon(
                            Icons.apps,
                            color: Colors.black,
                          ),
                          text: 'apps',
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          body: TabBarView(
            children: [
              _getListaMisiones(colecTodosLosUsuarios, args, puntos),
              Icon(Icons.directions_transit),
            ],
          ),
        ));
  }

  ///Devuelve el indicador de los puntos del usuarrio tutorado en tiempo real


  static Widget _getListaMisiones( collectionReferenceUsers, TransfDatosUserTutorado args, dynamic puntos) {
    //Toma los puntos totales en tiempo real, sin necedidad de reiniciar el widget
   return StreamBuilder(
        stream: collectionReferenceUsers.doc(args.snap.reference.id.trim()).collection('rolTutorado').doc(CurrentUser.getIdCurrentUser()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data as DocumentSnapshot;
          return StreamBuilder(
            stream: args.collectionReferenceMisiones.snapshots(),
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
                        documentSnapshot['solicitu_confirmacion'], args.snap.id.trim(), context, documentSnapshot.reference,
                        documentSnapshot['recompensaMision'],userDocument['puntosTotal']
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );;
        }
    );


  }
}

//Clipper customizado
class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 95, 95);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}
/*
Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: ClipOval(
                          clipper: MyClip(),
                          child: Image.network(
                              'https://lh3.googleusercontent.com/a-/AFdZucqG-OoiZpmpl7-MotCx9riNufTDF71pHPUGlDwG=s96-c',
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Expanded(flex: 6, child: LinearPercentIndicator(
                      animation: true,
                      lineHeight: 20.0,
                      animateFromLastPercent: true,
                      animationDuration: 1000,
                      percent: 0.9,
                      center: Text("90XP"),
                      barRadius: Radius.circular(10),
                      progressColor: Colors.amber,
                    ),),
                    Expanded(flex: 1, child: Text(''))
                  ],
                ),
              ),
              Row(children: [Padding(padding: EdgeInsets.only(left: 20, top: 10), child: Text('Maikel'),)],),

              const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(icon: Icon(Icons.directions_transit)),
                  Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
            ],
          )
 */