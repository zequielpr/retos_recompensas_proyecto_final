import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntp/ntp.dart';
import 'package:readmore/readmore.dart';
import 'package:retos_proyecto/recursos/Colores.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminRoles.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../../../recursos/DateActual.dart';
import '../../../../../widgets/Cards.dart';
import '../../AdminSala.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Misiones extends StatelessWidget {
  final CollectionReference collectionMisiones;
  final BuildContext contextSala;
  AppLocalizations? valores;
  Misiones(
      {Key? key, required this.collectionMisiones, required this.contextSala})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
          //listar misiones
          child: StreamBuilder(
        stream: collectionMisiones.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (streamSnapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text(valores?.crear_mision as String),
            );
          }
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Cards.getCardMisionInicio(
                    documentSnapshot, context, valores);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
    ;
  }
}

//Añadir misión --------------------------------------------------------------------------------------------------------------

class AddMision extends StatefulWidget {
  final BuildContext contextSala;
  final CollectionReference collectionReferenceMisiones;
  AddMision(
      {Key? key,
      required this.collectionReferenceMisiones,
      required this.contextSala})
      : super(key: key);

  @override
  State<AddMision> createState() =>
      AddMisionState(collectionReferenceMisiones, contextSala);
}

double pading_left = 10.0;
double pading_top = 5.0;
double pading_right = 10.0;
double pading_bottom = 10.0;
String hint = "nombre de misión";
bool oculto = false;
int maxLine = 1;
Color backgrund = Colors.white;

//var objetivoMision =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto, maxLine, backgrund, true);

class AddMisionState extends State<AddMision> {
  final BuildContext contextSala;
  final CollectionReference collectionReferenceMisiones;
  String puntosSeleccionados = '10';
  List<bool> isSelected = [true, false];
  String tipoMissSelect = "nomal";
  double _currentSliderValue = 15;
  var nombreMisionController = TextEditingController();
  var objetivoMisionController = TextEditingController();
  var isFieldNombreCorrect = true;
  var isFieldObjetiveCorrect = true;

  AppLocalizations? valores;

  AddMisionState(this.collectionReferenceMisiones, this.contextSala);

  var leftRight;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    leftRight = Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    return Scaffold(
        appBar: AppBar(
          title: Text(valores?.crear_mision as String),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(left: leftRight, right: leftRight),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: Pantalla.getPorcentPanntalla(
                        Espacios.top, context, 'y'),
                  ),

                  //Nombre de misión
                  TextField(
                    controller: nombreMisionController,
                    maxLines: 1,
                    maxLength: 15,
                    obscureText: oculto,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: valores?.nombre,
                    ),
                  ),

                  SizedBox(
                    height: Pantalla.getPorcentPanntalla(2, context, 'y'),
                  ),

                  //Objetivos de mision
                  TextField(
                    controller: objetivoMisionController,
                    maxLines: 4,
                    maxLength: 150,
                    obscureText: oculto,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: valores?.objetivo_mision,
                    ),
                  ),

                  //Puntuacion de la mision
                  _asignar_puntuacion(),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              Pantalla.getPorcentPanntalla(8, context, 'y'))),
                  //Boton para guardar mision
                  Padding(
                      padding: EdgeInsets.only(left: 70, right: 70),
                      child: SizedBox(
                        width: Pantalla.getPorcentPanntalla(50, context, 'x'),
                        height: Pantalla.getPorcentPanntalla(6, context, 'y'),
                        child: ElevatedButton(
                            onPressed: isFieldNombreCorrect &&
                                    isFieldObjetiveCorrect
                                ? () async {
                                    if (nombreMisionController
                                            .text.isNotEmpty &&
                                        objetivoMisionController
                                            .text.isNotEmpty) {
                                      DateTime dateActual =
                                          await DateActual.getActualDateTime();

                                      await collectionReferenceMisiones.add({
                                        'fecha': dateActual,
                                        'nombreMision':
                                            nombreMisionController.text,
                                        'objetivoMision':
                                            objetivoMisionController.text,
                                        'recompensaMision': puntos_recompensa,
                                        'completada_por':
                                            FieldValue.arrayUnion([]),
                                        'solicitu_confirmacion':
                                            FieldValue.arrayUnion([])
                                      }).then((value) {
                                        Navigator.pop(
                                            contextSala); //Regresa al contextxo de la sala
                                        ScaffoldMessenger.of(contextSala)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    valores?.mision_add_correct
                                                        as String)));
                                      });
                                      return;
                                    }

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

                                    var titulo =
                                        valores?.rellenar_campos as String;
                                    var message =
                                        valores?.rellenar_campo_contenido;

                                    Dialogos.mostrarDialog(
                                        actions, titulo, message, context);
                                  }
                                : null,
                            child: Text(valores?.guardar as String)),
                      )),
                ],
              )),
        ));
  }

  double puntos_recompensa = 5;
  Widget _asignar_puntuacion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: IconButton(
            onPressed: () => _add(),
            icon: Transform.scale(
              scaleX: 2.5,
              scaleY: 2.5,
              child: Icon(
                color: Colors.black54,
                Icons.add,
              ),
            ),
          ),
        ),
        Flexible(
            flex: 3,
            child: Card(
              elevation: 0,
                margin: EdgeInsets.only(
                    left: Pantalla.getPorcentPanntalla(3, context, 'x'),
                    right: Pantalla.getPorcentPanntalla(3, context, 'x')),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(color: Colores.colorPrincipal, width: 1)),
                child: SizedBox(
                  height: Pantalla.getPorcentPanntalla(25, context, 'x'),
                  width: Pantalla.getPorcentPanntalla(40, context, 'x'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${puntos_recompensa.toInt()}xp",
                        style: const TextStyle(fontSize: 50, color: Colors.black54),
                      )
                    ],
                  ),
                ))),
        Flexible(
          flex: 1,
          child: IconButton(
            onPressed: () => _substract(),
            icon: Transform.scale(
              scaleX: 2.5,
              scaleY: 2.5,
              child: Icon(
                Icons.remove,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int rest = 5;
  void _substract() {
    if (puntos_recompensa > 5) {
      setState(() {
        puntos_recompensa -= rest;
      });
    }
  }

  int sum = 5;
  void _add() {
    if (puntos_recompensa < 25){
      setState(() {
        puntos_recompensa += sum;
      });
    }

  }
}
