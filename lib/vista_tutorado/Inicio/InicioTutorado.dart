import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/TransferirDatos.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';
import 'package:retos_proyecto/vista_tutorado/Inicio/Cartera.dart';

import '../../MediaQuery.dart';
import '../../datos/DatosPersonalUser.dart';

class InicioTutorado extends StatefulWidget {
  final CollectionReference collectionReferenceUsers;
  const InicioTutorado({Key? key, required this.collectionReferenceUsers})
      : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _InicioTutorado(collectionReferenceUsers);
}

class _InicioTutorado extends State<InicioTutorado> {
  final CollectionReference collectionReferenceUsers;

  _InicioTutorado(this.collectionReferenceUsers);
  var idTutorActual = 'hr44Bc4CRqWJjFfDYMCBmu707Qq1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _showCajaRecompensa(collectionReferenceUsers),
          getBilleteraRecomensas(collectionReferenceUsers, context)
        ],
      ),
    );
  }

  //Caja de recompesa
  Widget _showCajaRecompensa(CollectionReference collectionReferenceUsers) {
    String tutorActual = 'hr44Bc4CRqWJjFfDYMCBmu707Qq1';
    DocumentReference docTutor = collectionReferenceUsers
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutorado')
        .doc(tutorActual);
    return StreamBuilder(
      stream: docTutor.snapshots(),
      builder: (context, data) {
        if (data.hasData) {
          DocumentSnapshot snapshot = data.data as DocumentSnapshot;

          return Container(
            margin: EdgeInsets.only(
                left: Pantalla.getPorcentPanntalla(4, context, 'x'),
                right: Pantalla.getPorcentPanntalla(4, context, 'x')),
            child: Column(
              children: [
                //Puntos acumulado
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: Pantalla.getPorcentPanntalla(2, context, 'y'),
                          bottom:
                              Pantalla.getPorcentPanntalla(6, context, 'y')),
                      child: Text('Acumulados: ' +
                          snapshot['puntos_acumulados'].toString()),
                    )
                  ],
                ),

                //Barra de avance
                Row(
                  children: [
                    Expanded(
                        flex: 6,
                        child: DatosPersonales.getIndicadoAvance(
                            CurrentUser.getIdCurrentUser(),
                            collectionReferenceUsers,
                            idTutorActual)),
                    Expanded(flex: 1, child: Icon(Icons.flag)),
                    Expanded(flex: 1, child: Text('200'))
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(
                      top: Pantalla.getPorcentPanntalla(10, context, 'y'),
                      bottom: Pantalla.getPorcentPanntalla(6, context, 'y')),
                  height: Pantalla.getPorcentPanntalla(29, context, 'y'),
                  width: Pantalla.getPorcentPanntalla(80, context, 'x'),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  side: BorderSide(
                                      color: Colors.black26, width: 2)))),
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
                                      await docTutor
                                          .collection('billeteraRecompensas')
                                          .doc()
                                          .set({
                                        'titulo': key,
                                        'contenido': value,
                                        'fehca_reclamo': DateTime.now()
                                      });
                                    });
                                    //Eliminar la recompensa reclamada
                                    await docTutor
                                        .update({'recompensa_x_200': {}});

                                    //Mostrar la recompensa obtenida
                                    recompensa.forEach((key, value) {
                                      showDialog<void>(
                                        context: context,
                                        // false = user must tap button, true = tap outside dialog
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: Text('Recompensa'),
                                            content: Text(key + ': ' + value),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('ver billetera?'),
                                                onPressed: () {
                                                  Navigator.of(dialogContext)
                                                      .pop(); // Dismiss alert dialog
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
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
                                  print('se reclama');
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
                                      return AlertDialog(
                                        title:
                                            Text('Remcompensa no disponible'),
                                        content: Text(
                                            'Pongase en contacto con su tutor'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('ok'),
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Dismiss alert dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  print(
                                      'Actualmente no hay recompensas para reclamar, pongase en contacto con su tutor');
                                }
                          : null,
                      child: Text('Foto de algo')),
                )
              ],
            ),
          );
        }
        return Text('');
      },
    );
  }

  //Billetera de recompensas
  Widget getBilleteraRecomensas(CollectionReference collectionReferenceUsers, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        var datos = HelperCartera(collectionReferenceUsers);
        Navigator.pushNamed(context, Cartera.ROUTE_NAME, arguments: datos);
      },
      child: Text('Foto de billetera o bolsa'),
    );
  }
}

//DatosPersonales.getIndicadoAvance(doc)
