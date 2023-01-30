import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../MediaQuery.dart';
import '../../../Rutas.gr.dart';
import '../../../datos/DatosPersonalUser.dart';
import '../../../datos/SalaDatos.dart';
import '../../../datos/TransferirDatos.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InicioTutor extends StatefulWidget {
  const InicioTutor({Key? key}) : super(key: key);

  @override
  State<InicioTutor> createState() => _InicioTutorState();
}

class _InicioTutorState extends State<InicioTutor> {
  static AppLocalizations? valores;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: Pantalla.getPorcentPanntalla(4, context, 'x'),
      ),
      child: getSalas(),
    );
    ;
  }

  static Widget getSalas() {
    return StreamBuilder<QuerySnapshot>(
      stream: Coleciones.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutor').doc(CurrentUser.getIdCurrentUser()).collection('salas')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(valores?.ha_error as String);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if(snapshot.data?.docs.isEmpty == true){
          return  Center(
            child: Text(valores?.crea_sala as String),
          );
        }

        return ListView(
          padding: EdgeInsets.only(
              top: Pantalla.getPorcentPanntalla(2, context, 'y')),
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return StreamBuilder(
                    stream: document.reference
                        .collection('usersTutorados')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.data?.docs.isEmpty == true){
                      }

                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
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
                                      style:  const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                getSalaUsers(document.reference)
                              ],
                            ),
                          );
                        }
                        return const Text('');
                      }
                      return const Text('');
                    });


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
          return Text(valores?.ha_error as String);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        return SizedBox(
          height: snapshot.data!.docs.length *
              Pantalla.getPorcentPanntalla(11, context, 'y'),
          width: 340,
          child: ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  if(document.id.isNotEmpty){
                    return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            Pantalla.getPorcentPanntalla(2.2, context, 'y')),
                        child: ListTile(
                          onTap: () {
                            var sala = SalaDatos(documentReference, '');
                            TransfDatosUserTutorado datosUser =
                            TransfDatosUserTutorado(
                                sala.getColecMisiones, document);
                            context.router.push(UserTutorado(args: datosUser));
                          },
                          style: ListTileStyle.drawer,
                          contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          visualDensity: VisualDensity.comfortable,
                          leading: DatosPersonales.getAvatar( document.id, 26),
                          title: DatosPersonales.getIndicadoAvance(
                              document.id,
                              Coleciones.COLECCION_USUARIOS,
                              CurrentUser.getIdCurrentUser()),
                          subtitle: Padding(
                            padding: EdgeInsets.only(
                                left: Pantalla.getPorcentPanntalla(
                                    3, context, 'x')),
                            child: DatosPersonales.getDato(
                                document.id,
                                'nombre_usuario', TextStyle()),
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
                  return const Text('');
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
    if(idUser.isNotEmpty) {
      return StreamBuilder(
          stream: Coleciones.COLECCION_USUARIOS
              .doc(idUser)
              .collection('rolTutorado')
              .doc(CurrentUser.getIdCurrentUser())
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (!snapshot.data ['recompensa_x_200'].isEmpty) {
                return const Icon(Icons.redeem);
              } else {
                return const Icon(Icons.check_box_outline_blank);
              }
            } else if (snapshot.hasError) {
              return const Icon(Icons.error_outline);
            } else {
              return const CircularProgressIndicator();
            }
          });
    }
    return const Text('');
  }
}
