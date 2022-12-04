import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../MediaQuery.dart';
import '../../../Rutas.gr.dart';
import '../../../datos/DatosPersonalUser.dart';
import '../../../datos/SalaDatos.dart';
import '../../../datos/TransferirDatos.dart';

class InicioTutor extends StatefulWidget {
  const InicioTutor({Key? key}) : super(key: key);

  @override
  State<InicioTutor> createState() => _InicioTutorState();
}

class _InicioTutorState extends State<InicioTutor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getSalas(),
      padding: EdgeInsets.only(
        left: Pantalla.getPorcentPanntalla(4, context, 'x'),
      ),
    );
    ;
  }

  static Widget getSalas() {
    return StreamBuilder<QuerySnapshot>(
      stream: CollecUser.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutor').doc(CurrentUser.getIdCurrentUser()).collection('salas')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Ha ocurrido un error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Cargando...");
        }

        return ListView(
          padding: EdgeInsets.only(
              top: Pantalla.getPorcentPanntalla(2, context, 'y')),
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                print('nombre ${data['NombreSala']}');

                return StreamBuilder(
                    stream: document.reference
                        .collection('usersTutorados')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Pantalla.getPorcentPanntalla(
                                          3, context, 'y'),
                                      bottom: Pantalla.getPorcentPanntalla(
                                          2, context, 'y')),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      data['NombreSala'],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                getSalaUsers(document.reference)
                              ],
                            ),
                          );
                        }
                        return Text('');
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error_outline);
                      } else {
                        return CircularProgressIndicator();
                      }
                    });

                return Text('data');
              })
              .toList()
              .cast(),
        );
      },
    );
  }

  //

  static Widget getSalaUsers(DocumentReference documentReference) {
    return StreamBuilder<QuerySnapshot>(
      stream: documentReference.collection('usersTutorados').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Ha ocurrido un error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Cargando...");
        }
        return SizedBox(
          height: snapshot.data!.docs.length *
              Pantalla.getPorcentPanntalla(11, context, 'y'),
          width: 340,
          child: ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  print('nombre ${document.id}');
                  if(document.id.length > 0){
                    return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            Pantalla.getPorcentPanntalla(2.2, context, 'y')),
                        child: ListTile(
                          onTap: () {
                            var sala = SalaDatos(documentReference);
                            TransfDatosUserTutorado datosUser =
                            TransfDatosUserTutorado(
                                sala.getColecMisiones, document);
                            context.router.push(UserTutorado(args: datosUser));
                          },
                          style: ListTileStyle.drawer,
                          contentPadding: EdgeInsets.all(0),
                          dense: true,
                          visualDensity: VisualDensity.comfortable,
                          leading: DatosPersonales.getAvatar( document.id, 26),
                          title: DatosPersonales.getIndicadoAvance(
                              document.id,
                              CollecUser.COLECCION_USUARIOS,
                              CurrentUser.getIdCurrentUser()),
                          subtitle: Padding(
                            padding: EdgeInsets.only(
                                left: Pantalla.getPorcentPanntalla(
                                    3, context, 'x')),
                            child: DatosPersonales.getDato(
                                document.id,
                                'nombre_usuario'),
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                Pantalla.getPorcentPanntalla(2, context, 'y'),
                                right: Pantalla.getPorcentPanntalla(
                                    2, context, 'y')),
                            child: comprobarRecompensa(document.id),
                          ),
                        ));
                  }
                  return Text(
                    document.id,
                    style: TextStyle(fontSize: 16),
                  );
                })
                .toList()
                .cast(),
          ),
        );
      },
    );
  }

  //Comprobar si el usuario tiene una recompensa por reclamar
  static Widget comprobarRecompensa(String idUser) {
    if(idUser.length > 0) {
      return StreamBuilder(
          stream: CollecUser.COLECCION_USUARIOS
              .doc(idUser)
              .collection('rolTutorado')
              .doc(CurrentUser.getIdCurrentUser())
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (!snapshot.data ['recompensa_x_200'].isEmpty) {
                return Icon(Icons.redeem);
              } else {
                return Icon(Icons.check_box_outline_blank);
              }
            } else if (snapshot.hasError) {
              return Icon(Icons.error_outline);
            } else {
              return CircularProgressIndicator();
            }
          });
    }
    return Text('');
  }
}
