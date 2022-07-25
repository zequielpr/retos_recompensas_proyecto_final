import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../../../../../widgets/Cards.dart';
import '../../../../../widgets/Fields.dart';

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
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Cards.getCardMisionInicio(documentSnapshot);
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
            width: 400,
            height: 50,
            child: Container(
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        Navigator.of(contextSala).push(MaterialPageRoute(
                            builder: (context) => AddMision(
                                  collectionReferenceMisiones:
                                      collectionMisiones,
                                  contextSala: contextSala,
                                )));
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )));
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
        child: ListView(
      children: <Widget>[
        const SizedBox(
          height: 100,
        ),

        Padding(
          padding: EdgeInsets.only(
              left: pading_left, right: pading_right, bottom: 20),
          child: ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    tipoMissSelect = 'Especial';
                    isSelected[buttonIndex] = true;
                  } else {
                    tipoMissSelect = 'Normal';
                    isSelected[buttonIndex] = false;
                  }
                }
                print(tipoMissSelect);
              });
            },
            isSelected: isSelected,
            children: const <Widget>[
              //Icon(Icons.ac_unit),
              //Icon(Icons.call),
              Text('nomal'),
              Text('Especial')
            ],
          ),
        ),

        //Nombre de misión
        nombreMision.getInstance,

        //Objetivos de mision
        objetivoMision.getInstance,

        /*
       Padding(padding: EdgeInsets.only(left: pading_left, right: pading_right), child:
        Row(children: [
          Text('Puntos de recompensa:'),
          Padding(padding: EdgeInsets.only(left: 10, right: 10), child:  DropdownButton<String>(
            value: puntosSeleccionados,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                puntosSeleccionados = newValue!;
              });
            },
            items: <String>['10', '20', '30']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),),

        ],),
       ),
      */
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
                  await collectionReferenceMisiones.add({
                    'fecha': DateTime.now(),
                    'nombreMision': nombreMision.getValor,
                    'objetivoMision': objetivoMision.getValor,
                    'recompensaMision': _currentSliderValue,
                    'tipo': tipoMissSelect,
                    'completada_por': FieldValue.arrayUnion([]),
                    'solicitu_confirmacion': FieldValue.arrayUnion([])
                  }).then((value) {
                    Navigator.pop(
                        contextSala); //Regresa al contextxo de la sala
                    ScaffoldMessenger.of(contextSala).showSnackBar(
                        const SnackBar(
                            content: Text('Mision añadida correctamente')));
                  });
                },
                child: Text('Guardar'))),
      ],
    ));
  }
}

/*
class AddMision extends StatelessWidget {
  final CollectionReference collectionMisiones;

  AddMision ( {Key? key, required this.collectionMisiones}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pading_left = 10.0;
    double pading_top = 5.0;
    double pading_right = 10.0;
    double pading_bottom = 10.0;
    String hint = "nombre de misión";
    bool oculto = false;
    //Creando los field Para añadir las misiones
    var nombreMision =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto);
    hint = 'Objetivo';
    var objetivo =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto);
    hint = 'Recompensa';
    var recompensaMision =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto);
    hint = 'Tipo';
    var tipo =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto);
    List<String> listaDeOpciones = <String>["A","B","C","D","E","F","G"];
    String? dropdownValue = 'One';
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text('crear Misión'),
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            nombreMision.getInstance,
            objetivo.getInstance,
            Padding(padding: EdgeInsets.only(left: 10, right: 10), child:
            Row(children: [Text('tipo: '),],),),
            tipo.getInstance,
            recompensaMision.getInstance,

           Padding(padding: EdgeInsets.only(left: 70, right: 70), child: ElevatedButton(onPressed: (){}, child: Text('Guardar')),)
          ],
        )

      ),
    );
    ;
  }
}
*/
