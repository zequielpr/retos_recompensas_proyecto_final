import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../datos/DatosPersonalUser.dart';
import '../../../../datos/SalaDatos.dart';
import '../../../../datos/TransferirDatos.dart';
import '../../../../widgets/Cards.dart';

class UserTutoradoDescrip extends StatefulWidget {
  static const ROUTE_NAME = '/UserTutoradoDescrip';
  const UserTutoradoDescrip({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserTotoradoDescrip();
}

class _UserTotoradoDescrip extends State<UserTutoradoDescrip> {
  double _currentSliderValue = 15;
  static var antiguo;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TransfDatosUserTutorado;
    final colecTodosLosUsuarios = args.snap.reference.parent.parent?.parent
        .parent?.parent; //navega hacia la coleccion de todos los usuarios
    var puntoTotal = args.snap['puntosTotal'].toDouble();

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
                              child: ClipOval(
                                clipper: MyClip(),
                                child: Image.network(
                                    'https://lh3.googleusercontent.com/a-/AFdZucqG-OoiZpmpl7-MotCx9riNufTDF71pHPUGlDwG=s96-c',
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: getIndicadoAvance(args.snap)
                          ),
                          Expanded(flex: 1, child: Text(''))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: DatosPersonales.getDato(colecTodosLosUsuarios, args.snap.id, 'nombre'),
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
              _getListaMisiones(args),
              Icon(Icons.directions_transit),
            ],
          ),
        ));
  }

  ///Devuelve el indicador de los puntos del usuarrio tutorado en tiempo real
  Widget getIndicadoAvance(DocumentSnapshot snap){
    return StreamBuilder(
        stream: snap.reference.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data as DocumentSnapshot;
          return LinearPercentIndicator(
            linearGradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xff1f005c),
                Color(0xff5b0060),
                Color(0xff870160),
                Color(0xffac255e),
                Color(0xffca485c),
                Color(0xffe16b5c),
                Color(0xfff39060),
                Color(0xffffb56b),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
            ),


            animation: true,
            lineHeight: 20.0,
            animateFromLastPercent: true,
            animationDuration: 1000,
            percent: userDocument['puntosTotal']/200,
            center: Text(userDocument['puntosTotal'].toString()),
            barRadius: Radius.circular(10),
            //progressColor: Colors.amber,
          );
        }
    );
  }

  Widget _getListaMisiones(TransfDatosUserTutorado args) {
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
                  documentSnapshot['solicitu_confirmacion'], args.snap.id.trim(), context, documentSnapshot.reference);
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
