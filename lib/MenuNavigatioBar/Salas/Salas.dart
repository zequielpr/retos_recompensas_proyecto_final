import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminRoles.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';

import '../../datos/Colecciones.dart';
import '../../widgets/Cards.dart';
import '../../widgets/Dialogs.dart';
import '../Perfil/admin_usuarios/Admin_tutores.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Salas extends StatefulWidget {
  const Salas({Key? key}) : super(key: key);

  @override
  State<Salas> createState() => _SalasState();
}

class _SalasState extends State<Salas> {
  var currentTutor;
  AppLocalizations? valores;
  void initCurrentTutor(currentTutor) {
    if (mounted) {
      setState(() {
        this.currentTutor = currentTutor;
      });
    }
  }

  void initState() {
    UsuarioTutores.setCurrentUser(initCurrentTutor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(valores?.salas as String),
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
            ? listaSalasVistaTutorado()
            : _getVistaSalasVistaTutor(context, Coleciones.COLECCION_USUARIOS),
      ),
    );
    ;
  }

  Widget listaSalasVistaTutorado() {
    if (currentTutor != null && currentTutor.length != 0) {
      return _listarVistaTutorados(
          context, Coleciones.COLECCION_USUARIOS, currentTutor);
    } else {
      return Center(
        child: Text(valores?.no_tutoria as String),
      );
    }
  }

  //Vista de las salas para los tutorados
  _listarVistaTutorados(BuildContext context,
      CollectionReference collecionUsuarios, tutorActual) {
    List<dynamic> listaIdasSalas = [];

    return StreamBuilder(
        stream: collecionUsuarios
            .doc(CurrentUser.getIdCurrentUser())
            .collection('rolTutorado')
            .doc(tutorActual)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var documentSnapShot = snapshot.data as DocumentSnapshot;

          try{
            //Tomar las snapshot necesesarias
            listaIdasSalas = documentSnapShot[
            "salas_id"]; //Ids de las salas a las que está añadido el usuario actual
          }catch(e){

          }

          if(listaIdasSalas.isEmpty){
            return Center(
              child: Text(valores?.unete_sala as String),
            );;
          }

          //Recorre las lista de Ids de salas y obtiene las snap del tutor actual
          return ListView.builder(
            itemBuilder: (BuildContext, index) {
              return StreamBuilder(
                  stream: collecionUsuarios
                      .doc(tutorActual)
                      .collection('rolTutor')
                      .doc(tutorActual)
                      .collection('salas')
                      .doc(listaIdasSalas[index])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
            scrollDirection: Axis.vertical,
          );
        });
  }

  Widget _getVistaSalasVistaTutor(
      BuildContext context, CollectionReference collecionUsuarios) {
    //lista todas las salas que ha creado el usuario actual
    return StreamBuilder(
      stream: collecionUsuarios
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutor')
          .doc(CurrentUser.getIdCurrentUser())
          .collection('salas')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (streamSnapshot.data?.docs.isEmpty == true) {
          return Center(
            child: Text(valores?.crea_sala as String),
          );
        }
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
          child: Text(''),
        );
      },
    );
  }

  //Contar numero de salas creadas
  Future<int> getNumerosalas() async {
    return await Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutor')
        .doc(CurrentUser.getIdCurrentUser())
        .collection('salas')
        .get()
        .then((value) => value.size);
  }

  //Funcion para crear nuevas salas
  Future<void> crearSala() async {
    actions(BuildContext context) {
      return <Widget>[
        TextButton(
          onPressed: () => context.router.pop(),
          child: Text('Ok'),
        )
      ];
    }

    ;

    var title = valores?.num_max_salas_titulo as String;
    var message = valores?.num_max_salas_contenido as String;
    var numeroDeSalas = await getNumerosalas();
    numeroDeSalas <= 3
        ? showModalCrearSala()
        : Dialogos.mostrarDialog(actions, title, message, context);
  }

  Future<void> showModalCrearSala() async {
    var top = Pantalla.getPorcentPanntalla(2, context, 'y');
    bool nombreSalaIsEmpty = false;
    var h = Pantalla.getPorcentPanntalla(4, context, "y");
    bool botonActivo = true;
    var heightLinea = Pantalla.getPorcentPanntalla(1, context, "y");

    var nombreSala = TextEditingController();
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: top,
                left:
                    Pantalla.getPorcentPanntalla(Espacios.leftRight, ctx, 'x'),
                right:
                    Pantalla.getPorcentPanntalla(Espacios.leftRight, ctx, 'x'),
                bottom: Pantalla.getPorcentPanntalla(2, context, 'y'),
                // prevent the soft keyboard from covering text fields
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*  Row(children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.cancel_outlined))
                ],),*/
                  Card(
                    elevation: 0,
                    color: Colors.black26,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Container(
                      width: 100,
                      height: heightLinea,
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Text(
                        valores?.crea_nueva_sala as String,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),

                  SizedBox(
                    height: h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      maxLength: 16,
                      controller: nombreSala,
                      decoration:
                          InputDecoration(labelText: valores?.nombre_sala),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: nombreSalaIsEmpty
                        ? Text(valores
                        ?.escribit_nombre_sala as String,
                            style: const TextStyle(color: Colors.red),
                          )
                        : const Text(''),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  //Boton de enviar solicitud
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: botonActivo == true
                          ? () async {
                              if (nombreSala.text.isEmpty) {
                                setState(() {
                                  nombreSalaIsEmpty = true;
                                });
                                return;
                              }
                              final String name = nombreSala.text;

                              if (name.isNotEmpty) {
                                // Persist a new product to Firestore
                                await Coleciones.COLECCION_USUARIOS
                                    .doc(CurrentUser.getIdCurrentUser())
                                    .collection('rolTutor')
                                    .doc(CurrentUser.getIdCurrentUser())
                                    .collection('salas')
                                    .add({
                                  "NombreSala": name,
                                  'numMisiones': 0,
                                  'numTutorados': 0
                                }).whenComplete(() => {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(valores
                                                          ?.sala_creada_correct
                                                      as String)))
                                        });
                                nombreSala.text = '';
                              }

                              // Hide the bottom sheet
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: Text(valores?.crea_sala as String),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }
}
