import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminRoles.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../../../widgets/Cards.dart';
import '../../../../../widgets/Fields.dart';
import '../../AdminSala.dart';

class Misiones extends StatelessWidget {
  final CollectionReference collectionMisiones;
  final BuildContext contextSala;
  Misiones(
      {Key? key, required this.collectionMisiones, required this.contextSala})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          //listar misiones
          child: StreamBuilder(
        stream: collectionMisiones.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }

          if(streamSnapshot.data?.docs.isEmpty == true){
            return const Center(
              child: Text('Crea una misión'),
            );
          }
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Cards.getCardMisionInicio(documentSnapshot, context);
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
class AddMision extends StatelessWidget {
  final BuildContext contextSala;
  final CollectionReference collectionReferenceMisiones;
  const AddMision(
      {Key? key,
      required this.collectionReferenceMisiones,
      required this.contextSala})
      : super(key: key);

  static const String _title = 'Añadir mision';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: Center(
        child: MyStatefulWidget(
            collectionReferenceMisiones: collectionReferenceMisiones,
            contextSala: contextSala),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final BuildContext contextSala;
  final CollectionReference collectionReferenceMisiones;
  MyStatefulWidget(
      {Key? key,
      required this.collectionReferenceMisiones,
      required this.contextSala})
      : super(key: key);

  @override
  State<MyStatefulWidget> createState() =>
      MyStatefulWidgetState(collectionReferenceMisiones, contextSala);
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

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  final BuildContext contextSala;
  final CollectionReference collectionReferenceMisiones;
  var nombreMision = Fields(pading_left, pading_top, pading_right,
      pading_bottom, 'Nombre de misión', oculto, 1, backgrund, true);
  var objetivoMision = Fields(
      pading_left,
      pading_top,
      pading_right,
      pading_bottom,
      'Escriba el objetivo de la mision aquí',
      oculto,
      4,
      Colors.white10,
      true);
  String puntosSeleccionados = '10';
  List<bool> isSelected = [true, false];
  String tipoMissSelect = "nomal";
  double _currentSliderValue = 15;

  MyStatefulWidgetState(this.collectionReferenceMisiones, this.contextSala);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: Pantalla.getPorcentPanntalla(4, context, 'y'),
        ),

        //Nombre de misión
        nombreMision.getInstance,

        //Objetivos de mision
        objetivoMision.getInstance,

        Slider(
          value: _currentSliderValue,
          max: 25,
          divisions: 5,
          label: _currentSliderValue.round().toString() + ' puntos.',
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),

        //Boton para guardar mision
        Padding(
            padding: EdgeInsets.only(left: 70, right: 70),
            child: ElevatedButton(
                onPressed: () async {
                  if (nombreMision.getValor.isNotEmpty &&
                      objetivoMision.getValor.isNotEmpty) {
                    await collectionReferenceMisiones.add({
                      'fecha': DateTime.now(),
                      'nombreMision': nombreMision.getValor,
                      'objetivoMision': objetivoMision.getValor,
                      'recompensaMision': _currentSliderValue,
                      'completada_por': FieldValue.arrayUnion([]),
                      'solicitu_confirmacion': FieldValue.arrayUnion([])
                    }).then((value) {
                      Navigator.pop(
                          contextSala); //Regresa al contextxo de la sala
                      ScaffoldMessenger.of(contextSala).showSnackBar(
                          const SnackBar(
                              content: Text('Mision añadida correctamente')));
                    });
                    return;
                  }

                  actions(BuildContext context){
                    return <Widget>[
                      TextButton(
                        onPressed: () {
                          context.router.pop();
                        },
                        child: const Text('Ok'),
                      ),
                    ];
                  }

                  var titulo = const Text('Rellenar campo', textAlign: TextAlign.center);
                  var message = const Text(
                    'Es necesario asignar un titulo y un objetivo para crear una misión',
                    textAlign: TextAlign.center,
                  );

                  Dialogos.mostrarDialog(actions, titulo, message, context);


                },
                child: Text('Guardar'))),
      ],
    ));
  }
}
