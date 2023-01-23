import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Servicios/Solicitudes/AdminSolicitudes.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';
import '../../../../../../Rutas.gr.dart';
import '../../../../../../datos/DatosPersonalUser.dart';
import '../../../../../../datos/SalaDatos.dart';
import '../../../../../../datos/TransferirDatos.dart';
import '../../../../../../datos/UsuarioActual.dart';
import '../../../../../../widgets/Dialogs.dart';
import 'ExpulsarDeSala.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListUsuarios extends StatelessWidget {
  final CollectionReference collectionReferenceUsuariosTutorados;
  final BuildContext contextSala;
  final CollectionReference collectionReferenceMisiones;
  ListUsuarios(
      {Key? key,
      required this.collectionReferenceUsuariosTutorados,
      required this.contextSala,
      required this.collectionReferenceMisiones})
      : super(key: key);
  AppLocalizations? valores;

  static const String titulo = 'Expulsar';
  static const String mensaje = '¿Deseas explusar este usuario de esta sala?';

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: collectionReferenceUsuariosTutorados.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (streamSnapshot.data?.docs.isEmpty == true) {
              return  Center(
                child: Text(valores?.add_usuario as String),
              );
            }

            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  var idSala = documentSnapshot.reference.parent.parent?.id;
                  return Card(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(
                        left: Pantalla.getPorcentPanntalla(4, context, 'x'),
                        right: Pantalla.getPorcentPanntalla(2, context, 'x'),
                        top: Pantalla.getPorcentPanntalla(1, context, 'y')),
                    elevation: 0,
                    child: ListTile(
                      onTap: () {
                        var datos = TransfDatosUserTutorado(
                            collectionReferenceMisiones, documentSnapshot);
                        contextSala.router.push(UserTutorado(args: datos));
                        /* Navigator.pushNamed(
                        context,
                        MenuSala.routeName,
                        arguments: TransferirDatos(
                          Text(documentSnapshot['NombreSala']).data.toString(),
                          collecionUsuarios.doc(documentSnapshot.id),
                        ),
                      );
*/
                        //this.titulo = 'holaaa';

                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuSala()) );
                      },
                      leading:
                          DatosPersonales.getAvatar(documentSnapshot.id, 20),
                      title:DatosPersonales.getDato(
                          documentSnapshot.id, 'nombre', TextStyle()),
                      subtitle: DatosPersonales.getDato(
                          documentSnapshot.id, 'nombre_usuario', TextStyle()),
                      trailing: SizedBox(
                        width: Pantalla.getPorcentPanntalla(15, context, 'x'),
                        child: Row(
                          children: [
                            IconButton(
                                icon:
                                    const Icon(Icons.output_rounded, size: 25),
                                onPressed: () =>
                                    ExplusarDeSala.ExplusarUsuarioDesala(
                                        context,
                                        idSala,
                                        documentSnapshot.id,
                                        CurrentUser.getIdCurrentUser(),
                                        titulo,
                                        mensaje)),
                            // This icon button is used to delete a single product
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

//Enviar solici

class enviarSolicitudeUsuario {
  static InterfaceEnviarSolicitud(BuildContext context, String idSala, String nombreSala, AppLocalizations? valores) {
    var leftRight =
        Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    var _userNameController = TextEditingController();
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: Pantalla.getPorcentPanntalla(2, context, 'y'),
                left: leftRight,
                right: leftRight,
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
                    SizedBox(
                      height: Pantalla.getPorcentPanntalla(4, context, "y"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(valores?.enviar_solicitud as String,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: Pantalla.getPorcentPanntalla(1.5, context, "y"),
                ),
                TextField(
                  controller: _userNameController,
                  decoration:InputDecoration(labelText: valores?.nombre_usuario as String),
                ),
                SizedBox(
                  height: Pantalla.getPorcentPanntalla(2, context, 'y'),
                ),

                //Boton de enviar solicitud
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_userNameController.text.isEmpty) {
                          mostrarMensaje(context);
                          return;
                        }

                        var resultadoFinal = await Solicitudes.enviarSolicitud(
                            _userNameController.text,
                            idSala, nombreSala);

                        var colorSnackBar =
                            resultadoFinal == true ? Colors.green : Colors.red;
                        var mensaje = resultadoFinal == true
                            ? valores?.solicitud_enviada_correct as String
                            : valores?.error_enviar_solicitud as String;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: colorSnackBar,
                            content: Text(mensaje)));
                        Navigator.of(context).pop();
                      },
                      child: Text(valores?.enviar_solicitud as String)),
                )
              ],
            ),
          );
        });
  }

  static mostrarMensaje(BuildContext context) {
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

    var titulo = 'Nombre de usuario vacío';
    var message =
        'Es necesario escribir un nombre de usuario para enviar una solicitud';

    Dialogos.mostrarDialog(actions, titulo, message, context);
  }

  //Metodo para ennviar solicitud de usuario

}
