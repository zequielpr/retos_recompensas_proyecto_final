import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/Rutas.gr.dart';

import '../../../recursos/MediaQuery.dart';
import '../../../datos/DatosPersonalUser.dart';
import '../../../datos/UsuarioActual.dart';
import '../../../recursos/DateActual.dart';
import '../../../widgets/Dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InicioVistaTutorado {
  static Widget showCajaRecompensa(CollectionReference collectionReferenceUsers,
      String idTutorActual, changeImg, cofre, AppLocalizations? valores) {
    //Mensaje para cuendo no se encuentra ninguna recompensa disponible

    var tituloNoRecompensa = Text(
      '${valores?.recompensa_no_disponible}',
      style: const TextStyle(
          fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w600),
    );

    //Action
    var actionOk = const Text(
      "OK",
      style: TextStyle(color: Colors.blue, fontSize: 25.0),
      textAlign: TextAlign.center,
    );

    DocumentReference docTutor = collectionReferenceUsers
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutorado')
        .doc(idTutorActual);
    return StreamBuilder(
      stream: docTutor.snapshots(),
      builder: (context, data) {
        print(' resultado: ${data.hasData}');
        if (!data.hasData) {
          return Text('${data.hasData}');
        }
        if (data.hasData == true) {
          DocumentSnapshot snapshot = data.data as DocumentSnapshot;

          return Container(
            margin: EdgeInsets.only(
                left: Pantalla.getPorcentPanntalla(4, context, 'x'),
                right: Pantalla.getPorcentPanntalla(4, context, 'x')),
            child: Column(
              children: [
                //Puntos acumulado
                Column(
                  children: [
                    SizedBox(
                      height: Pantalla.getPorcentPanntalla(4, context, 'y'),
                    ),
                    Text(
                      snapshot['puntos_acumulados'].toString(),
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: Pantalla.getPorcentPanntalla(15, context, 'y'),
                      bottom: Pantalla.getPorcentPanntalla(3, context, 'y')),
                  height: Pantalla.getPorcentPanntalla(29, context, 'y'),
                  width: Pantalla.getPorcentPanntalla(80, context, 'x'),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: snapshot['puntosTotal'] == 200
                          ? snapshot['recompensa_x_200'].isNotEmpty
                              ? () async {
                                  Map<String, dynamic> recompensa =
                                      snapshot['recompensa_x_200'];
                                  await docTutor
                                      .update({'puntosTotal': 0}).whenComplete(
                                          () async {
                                    //Reclama la recompensa a cambio de los 200 puntos
                                    snapshot['recompensa_x_200']
                                        .forEach((key, value) async {
                                      var fechaActual =
                                          await DateActual.getActualDateTime();
                                      await docTutor
                                          .collection('billeteraRecompensas')
                                          .doc()
                                          .set({
                                        'titulo': key,
                                        'contenido': value,
                                        'fehca_reclamo': fechaActual
                                      });
                                    });
                                    //Eliminar la recompensa reclamada
                                    await docTutor
                                        .update({'recompensa_x_200': {}});

                                    //Cambiar img cofre
                                    changeImg();

                                    var count = 0;
                                    Timer.periodic(const Duration(seconds: 1),
                                        (timer) {
                                      count++;
                                      if (count == 2) {
                                        //Mostrar la recompensa obtenida
                                        recompensa.forEach((key, value) {
                                          showDialog<void>(
                                            context: context,
                                            // false = user must tap button, true = tap outside dialog
                                            builder:
                                                (BuildContext dialogContext) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0)),
                                                elevation: 0.0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: dialogPulCofre(
                                                    context,
                                                    Text(
                                                      value,
                                                      style: TextStyle(
                                                          fontSize: 30.0,
                                                          color: Colors.black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    actionOk,
                                                    Text(
                                                      key,
                                                      style: const TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                              );
                                            },
                                          );
                                        });
                                        timer.cancel();
                                      }
                                    });

                                    if (snapshot['puntos_acumulados'] > 200) {
                                      await docTutor
                                          .update({'puntosTotal': 200});
                                      await docTutor.update({
                                        'puntos_acumulados':
                                            snapshot['puntos_acumulados'] - 200
                                      });
                                      return;
                                    }
                                    await docTutor.update({
                                      'puntosTotal':
                                          snapshot['puntos_acumulados']
                                    });
                                    await docTutor
                                        .update({'puntos_acumulados': 0});
                                  });
                                  //añadir la recompensa a la billetera
                                  /* docTutor.update({'billetera_recompensa': snapshot['recompensa_x_200']}).whenComplete(() => {
                    docTutor.set({'recompensa_x_200': {} })
                  });*/
                                }
                              : () {
                                  showDialog<void>(
                                    context: context,
                                    // false = user must tap button, true = tap outside dialog
                                    builder: (BuildContext dialogContext) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: dialogPulCofre(
                                            context,
                                            Image.asset(
                                                'lib/recursos/imgs/undraw_xmas_surprise_57p1.png'),
                                            actionOk,
                                            tituloNoRecompensa),
                                      );
                                    },
                                  );
                                }
                          : () => mostrarMensaje(
                              snapshot['puntosTotal'], context, valores),
                      child: Image.asset("lib/recursos/imgs/cofre/cofre.png")),
                ),
                DatosPersonales.getIndicadoAvance(
                    CurrentUser.getIdCurrentUser(),
                    collectionReferenceUsers,
                    idTutorActual)
              ],
            ),
          );
        }
        return Text('xxx');
      },
    );
  }

  static mostrarMensaje(
      puntosActuales, BuildContext context, AppLocalizations? valores) {
    actions(BuildContext context) {
      return <Widget>[
        TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: const Text('Ok'),
        ),
      ];
    }

    var titulo = '${valores?.puntos_insuficiente}';
    var content = Image.asset('lib/recursos/imgs/undraw_feeling_blue_4b7q.png');

    Dialogos.mostrarDialog(actions, titulo, content, context);
  }

  //Metodo para mostrar recompensa
  static Widget dialogPulCofre(
      BuildContext context, Widget mensaje, Widget action, title) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(),
            margin: EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 15.0,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 20,
                      child: title,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: mensaje,
                ) //
                    ),
                SizedBox(height: 24.0),
                InkWell(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.router.pop();
                      },
                      child: const Text(
                        "OK",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
