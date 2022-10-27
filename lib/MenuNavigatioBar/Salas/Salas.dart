import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminRoles.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../datos/CollecUsers.dart';
import '../../widgets/Cards.dart';
import '../Perfil/AdminTutores.dart';

class Salas extends StatefulWidget {
  const Salas({Key? key}) : super(key: key);

  @override
  State<Salas> createState() => _SalasState();
}

class _SalasState extends State<Salas> {
  var currentTutor;

  void initCurrentTutor(currentTutor) {
    setState(() {
      this.currentTutor = currentTutor;
    });
  }

  void initState() {
    var initCurrentTutor = this.initCurrentTutor;
    if (Roll_Data.ROLL_USER_IS_TUTORADO) {
      AdminTutores.setCurrentUser(initCurrentTutor);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Salas'),
        actions: [
          Roll_Data.ROLL_USER_IS_TUTORADO
              ? Text('')
              : IconButton(
                  onPressed: () async => crearSala(),
                  icon: Icon(Icons.add_box_outlined))
        ],
      ),
      body: Container(
        child: Roll_Data.ROLL_USER_IS_TUTORADO
            ? contenido()
            : getVistaSalasVistaTutor(context, CollecUser.COLECCION_USUARIOS),
      ),
    );
    ;
  }

  Widget contenido() {
    return currentTutor != null
        ? _listarVistaTutorados(
            context, CollecUser.COLECCION_USUARIOS, currentTutor)
        : Center(
            child: Text('Aun no tienes un tutor'),
          );
  }

  //Vista de las salas para los tutorados
  _listarVistaTutorados(BuildContext context,
      CollectionReference collecionUsuarios, tutorActual) {
    List<dynamic> listaIdasSalas;

    return StreamBuilder(
        stream: collecionUsuarios
            .doc(CurrentUser.getIdCurrentUser())
            .collection('rolTutorado')
            .doc(tutorActual)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var documentSnapShot = snapshot.data as DocumentSnapshot;

          //Tomar las snapshot necesesarias
          listaIdasSalas = documentSnapShot[
              "salas_id"]; //Ids de las salas a las que está añadido el usuario actual

          //Recorre las lista de Ids de salas y obtiene las snap del tutor actual
          return ListView.builder(
            itemBuilder: (BuildContext, index) {
              return StreamBuilder(
                  stream: collecionUsuarios
                      .doc(tutorActual)
                      .collection('rolTutor')
                      .doc(listaIdasSalas[index])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var documentSnapShot = snapshot.data as DocumentSnapshot;
                    return Cards.CardSalaVistaTutorado(
                        context, collecionUsuarios, documentSnapShot);
                  });
            },
            itemCount: listaIdasSalas.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            scrollDirection: Axis.vertical,
          );

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  static Widget getVistaSalasVistaTutor(
      BuildContext context, CollectionReference collecionUsuarios) {
    //lista todas las salas que ha creado el usuario actual
    return StreamBuilder(
      stream: collecionUsuarios
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutor')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Cards.vistaTutor(context, collecionUsuarios,
                  documentSnapshot); //Devuele la vista de la sala
            },
          );
        }

        //Circulo de carga que espera hasta que se cargue el contenido
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  //Contar numero de salas creadas
  Future<int> getNumerosalas() async {
    return await CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutor')
        .get()
        .then((value) => value.size);
  }

  //Funcion para crear nuevas salas
  Future<void> crearSala() async {
    var actions = <Widget>[
      TextButton(
        onPressed: () => context.router.pop(),
        child: Text('Ok'),
      )
    ];

    var title = const Text('Numero maximo de salas', textAlign: TextAlign.center);
    var message = const Text(
      'Numero maximo de salas alcanzado, debe eliminar una o más salas si desea crear una sala',
      textAlign: TextAlign.center,
    );
    var numeroDeSalas = await getNumerosalas();
    numeroDeSalas <=3?showModalCrearSala():AdminRoll.showMessaje(actions, title, message, context);


  }

  Future<void> showModalCrearSala() async{
    var nombreSala = TextEditingController();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*  Row(children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.cancel_outlined))
                ],),*/

                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Crear una nueva sala",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: Pantalla.getPorcentPanntalla(29, context, "x")),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close)),
                    )
                  ],
                ),
                /*const ListTile(
                    leading: Material(
                      color: Colors.transparent,
                    ),
                    title: Text(
                      "Enviar solicitud a usuario",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                ),*/
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: nombreSala,
                    decoration:
                    const InputDecoration(labelText: 'Nombre de sala'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //Boton de enviar solicitud
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    child: Text('Crear sala'),
                    onPressed: () async {
                      final String name = nombreSala.text;

                      if (name.isNotEmpty) {
                        // Persist a new product to Firestore
                        await CollecUser.COLECCION_USUARIOS
                            .doc(CurrentUser.getIdCurrentUser())
                            .collection('rolTutor')
                            .add({
                          "NombreSala": name,
                          'numMisiones': 0,
                          'numTutorados': 0
                        }).whenComplete(() => {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Sala creada correctamente')))
                        });
                        nombreSala.text = '';
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Escriba en nombre de la sala. Debe tener al menos dos letras')));
                      }

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
