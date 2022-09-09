import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/AddRewardUser.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

import '../../../../../../datos/DatosPersonalUser.dart';
import '../../../../../../datos/TransferirDatos.dart';
import '../../../../../../datos/UsuarioActual.dart';
import '../../../../../../widgets/Cards.dart';

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

  @override
  Widget build(BuildContext context) {
    final colecTodosLosUsuarios = args.snap.reference.parent.parent?.parent
        .parent?.parent; //navega hacia la coleccion de todos los usuarios

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: DatosPersonales.getDato(
                colecTodosLosUsuarios!, args.snap.id, 'nombre_usuario'),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
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
                              child: DatosPersonales.getAvatar(
                                  colecTodosLosUsuarios,
                                  args.snap.id.trim(),
                                  40),
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
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: DatosPersonales.getDato(colecTodosLosUsuarios,
                              args.snap.id.trim(), 'nombre'),
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
                          text: 'Recompensa',
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          body: TabBarView(
            children: [
              _getListaMisiones(colecTodosLosUsuarios, args, puntos),
              Center(
                child: getRecompensaForUser(),
              ),
            ],
          ),
        ));
  }

  ///Devuelve el indicador de los puntos del usuarrio tutorado en tiempo real

  static Widget _getListaMisiones(
      collectionReferenceUsers, TransfDatosUserTutorado args, dynamic puntos) {
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
                    return Cards.getCardMision(
                        documentSnapshot['nombreMision'],
                        documentSnapshot['objetivoMision'],
                        documentSnapshot['completada_por'],
                        documentSnapshot['solicitu_confirmacion'],
                        args.snap.id.trim(),
                        context,
                        documentSnapshot.reference,
                        documentSnapshot['recompensaMision'],
                        userDocument['puntosTotal']);
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
  Widget getRecompensaForUser() {
    return StreamBuilder<DocumentSnapshot>(
      stream: CollecUser.COLECCION_USUARIOS
          .doc(args.snap.reference.id.trim())
          .collection("rolTutorado")
          .doc(CurrentUser.getIdCurrentUser())
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
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
                Text('Añadir recompensa')
              ],
            );
          }

          var k;
          var contenido;

          snap['recompensa_x_200'].forEach((key, value) {
            k = key;
            contenido = value;
          });
          return Card(
            child: ListTile(
              title: Text(k),
              subtitle: Text(contenido),
            ),
          );
        }

        return IconButton(
            onPressed: () async => addReward(), icon: Icon(Icons.add));
      },
    );
  }

//Añdir recompensa al usuario tutorado
  Future<void> addReward() async {
    await CollecUser.COLECCION_USUARIOS
        .doc(args.snap.reference.id.trim())
        .collection("rolTutorado")
        .doc(CurrentUser.getIdCurrentUser())
        .update({
      "recompensa_x_200": {'hola': 'hola'}
    });
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
