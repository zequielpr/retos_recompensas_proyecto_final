import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Servicios/Solicitudes/AdminSolicitudes.dart';
import '../../../../../../Rutas.gr.dart';
import '../../../../../../datos/DatosPersonalUser.dart';
import '../../../../../../datos/SalaDatos.dart';
import '../../../../../../datos/TransferirDatos.dart';
import '../../../../../../datos/UsuarioActual.dart';
import '../../../../../../widgets/Dialogs.dart';
import 'ExpulsarDeSala.dart';

class ListUsuarios extends StatelessWidget {
  final CollectionReference collectionReferenceUsuariosTutorados;
  final CollectionReference collectionReferenceUsuariosDocPersonal;
  final BuildContext contextSala;
  final CollectionReference collectionReferenceMisiones;
  ListUsuarios(
      {Key? key,
      required this.collectionReferenceUsuariosTutorados,
      required this.collectionReferenceUsuariosDocPersonal,
      required this.contextSala,
      required this.collectionReferenceMisiones})
      : super(key: key);

  static const String titulo = 'Expulsar';
  static const String mensaje = '¿Deseas explusar este usuario de esta sala?';

  @override
  Widget build(BuildContext context) {
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
              return const Center(
                child: Text('Añade un usuario a tu tutoría'),
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
                      title: SalaDatos.getNombreUsuario(
                          collectionReferenceUsuariosDocPersonal,
                          documentSnapshot.id),
                      subtitle: DatosPersonales.getDato(
                          documentSnapshot.id, 'nombre_usuario'),
                      trailing: SizedBox(
                        width: 50,
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
  static InterfaceEnviarSolicitud(BuildContext context,
      CollectionReference collectionReferenceUser, String idSala) {
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Pantalla.getPorcentPanntalla(5, context, 'y'),
                    ),
                    Text(
                      "Enviar solicitud a usuario",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                TextField(
                  controller: _userNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de usuario'),
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
                            collectionReferenceUser,
                            idSala);

                        var colorSnackBar =
                            resultadoFinal == true ? Colors.green : Colors.red;
                        var mensaje = resultadoFinal == true
                            ? 'Solicitud enviada correctamente'
                            : 'Error al enviar solicitud, el usuario no existe';
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: colorSnackBar,
                            content: Text(mensaje)));
                        Navigator.of(context).pop();
                      },
                      child: Text('Enviar solicitud')),
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
