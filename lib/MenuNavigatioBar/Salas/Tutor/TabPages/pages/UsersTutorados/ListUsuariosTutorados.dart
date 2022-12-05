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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: collectionReferenceUsuariosTutorados.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  var idSala = documentSnapshot.reference.parent.parent?.id;
                  return Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Card(
                      color: Colors.transparent,
                      margin: const EdgeInsets.all(10),
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
                        subtitle: Text('xxx' + ' xp',
                            overflow: TextOverflow.ellipsis, maxLines: 1),
                        trailing: SizedBox(
                          width: 50,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.output_rounded,
                                      size: 25),
                                  onPressed: () => ExplusarDeSala.ExplusarUsuarioDesala(context, idSala, documentSnapshot.id)),
                              // This icon button is used to delete a single product
                            ],
                          ),
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
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                Align(alignment: Alignment.centerLeft, child: ElevatedButton(
                    onPressed: () async {
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
                    child: Text('Enviar solicitud')),)
              ],
            ),
          );
        });
  }

  //Metodo para ennviar solicitud de usuario

}
