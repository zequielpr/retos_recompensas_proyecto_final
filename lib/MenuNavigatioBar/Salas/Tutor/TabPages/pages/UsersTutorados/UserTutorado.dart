import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/AddRewardUser.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/ExpulsarDeSala.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/ListUsuariosTutorados.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';

import '../../../../../../Colores.dart';
import '../../../../../../datos/DatosPersonalUser.dart';
import '../../../../../../datos/TransferirDatos.dart';
import '../../../../../../datos/UsuarioActual.dart';
import '../../../../../../widgets/Cards.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTutorado extends StatefulWidget {
  final TransfDatosUserTutorado args;
  const UserTutorado({Key? key, required this.args}) : super(key: key);

  @override
  State<UserTutorado> createState() => _UserTutoradoState(args);
}

class _UserTutoradoState extends State<UserTutorado> {
  final TransfDatosUserTutorado args;
  _UserTutoradoState(this.args);
  double _currentSliderValue = 15;
  static var puntos;
  AppLocalizations? valores;

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    final colecTodosLosUsuarios = Coleciones
        .COLECCION_USUARIOS; //navega hacia la coleccion de todos los usuarios

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: DatosPersonales.getDato(
                args.snap.id, 'nombre_usuario', TextStyle()),
            actions: [
              IconButton(
                  onPressed: () => ExplusarDeSala.ExplusarUsuarioDesala(
                      context,
                      args.collectionReferenceMisiones.parent?.id,
                      args.snap.reference.id,
                      CurrentUser.getIdCurrentUser(),
                      ListaUsuarioState.titulo,
                      ListaUsuarioState.mensaje),
                  icon: Icon(Icons.output_rounded)),
            ],
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                    Pantalla.getPorcentPanntalla(28, context, 'y')),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: DatosPersonales.getAvatar(
                                args.snap.id.trim(), 40),
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: DatosPersonales.getIndicadoAvance(
                                args.snap.reference.id,
                                colecTodosLosUsuarios,
                                CurrentUser.getIdCurrentUser())),
                        Expanded(flex: 1, child: Text(''))
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: Pantalla.getPorcentPanntalla(
                                  Espacios.leftRight, context, 'x'),
                              top: Pantalla.getPorcentPanntalla(
                                  1, context, 'y')),
                          child: DatosPersonales.getDato(
                              args.snap.id.trim(), 'nombre', TextStyle()),
                        )
                      ],
                    ),
                    TabBar(
                      indicatorColor: Colores.colorPrincipal,
                      labelColor: Colors.black,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.flag,
                            color: Colors.black,
                          ),
                          text: '${valores?.misiones}',
                        ),
                        Tab(
                          icon: Icon(
                            Icons.apps,
                            color: Colors.black,
                          ),
                          text: '${valores?.recompensa}',
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          body: TabBarView(
            children: [
              _getListaMisiones(colecTodosLosUsuarios, args, puntos, valores),
              Center(
                child: getRecompensaForUser(valores),
              ),
            ],
          ),
        ));
  }

  ///Devuelve el indicador de los puntos del usuarrio tutorado en tiempo real

  static Widget _getListaMisiones(
      collectionReferenceUsers, TransfDatosUserTutorado args, dynamic puntos, AppLocalizations? valores) {
    //Toma los puntos totales en tiempo real, sin necedidad de reiniciar el widget
    return StreamBuilder(
        stream: collectionReferenceUsers
            .doc(args.snap.reference.id.trim())
            .collection('rolTutorado')
            .doc(CurrentUser.getIdCurrentUser())
            .snapshots(),
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
                    return Cards.getCardMision(documentSnapshot,
                        args.snap.id.trim(),
                        context,
                        documentSnapshot['recompensaMision'], valores, 'x');
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          ;
        });
  }

  //Recompensa que obtendrá el usuario
  Widget getRecompensaForUser(AppLocalizations? valores) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Coleciones.COLECCION_USUARIOS
          .doc(args.snap.reference.id.trim())
          .collection("rolTutorado")
          .doc(CurrentUser.getIdCurrentUser())
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${valores?.ha_error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if (snapshot.hasData) {
          var snap = snapshot.data as DocumentSnapshot;

          if (snap['recompensa_x_200'].isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    context.router.push(
                        AddRewardRouter(userId: args.snap.reference.id.trim()));
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 40,
                  ),
                ),
                Text('${valores?.add_recompensa}')
              ],
            );
          }

          var titulo_recompensa;
          var contenido;

          snap['recompensa_x_200'].forEach((key, value) {
            titulo_recompensa = key;
            contenido = value;
          });
          return Center(
            child: Container(
              margin: EdgeInsets.only(
                  left: Pantalla.getPorcentPanntalla(
                      Espacios.leftRight, context, 'x'),
                  right: Pantalla.getPorcentPanntalla(
                      Espacios.leftRight, context, 'x')),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    titulo_recompensa,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 30),
                  ),
                  Text(
                    contenido,
                    style: const TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
          );
          Card(
            child: ListTile(
              title: Text(titulo_recompensa),
              subtitle: Text(contenido),
            ),
          );
        }

        return Text('');
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
