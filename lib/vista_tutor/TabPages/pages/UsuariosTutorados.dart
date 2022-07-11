import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/Servicios/Solicitudes/AdminSolicitudes.dart';

import '../../../Servicios/Autenticacion/Autenticacion.dart';
import '../../../datos/SalaDatos.dart';

class Usuarios extends StatelessWidget {
  final CollectionReference collectionReferenceUsuariosTutorados;
  final CollectionReference collectionReferenceUsuariosDocPersonal;
  Usuarios(
      {Key? key,
      required this.collectionReferenceUsuariosTutorados,
      required this.collectionReferenceUsuariosDocPersonal})
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
                    return Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: FlatButton(
                          color: Colors.transparent,
                          splashColor: Colors.black26,
                          onPressed: () {
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
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 1,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4U5WnC1MCC0IFVbJPePBA2H0oEep5aDR_xS_FbNx3wlqqORv2QRsf5L5fbwOZBeqMdl4&usqp=CAU"),
                              ),
                              title: SalaDatos.getNombreUsuario(
                                  collectionReferenceUsuariosDocPersonal,
                                  documentSnapshot.id),
                              subtitle: Text(
                                  documentSnapshot['puntosTotal'].toString() +
                                      ' xp',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.more_vert,
                                            size: 25),
                                        onPressed: () {}),
                                    // Press this button to edit a single product

                                    IconButton(
                                      icon: const Icon(
                                          Icons.exit_to_app_outlined,
                                          color: Colors.red,
                                          size: 20),
                                      onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Expulsar usuario'),
                                          content: const Text(
                                              'Al expulsar este usuario se perderán los logros conseguidos en esta sala'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                print('no');
                                                Navigator.pop(
                                                    context, 'Cancel');
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                print('si');
                                                Navigator.pop(context, 'OK');
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // This icon button is used to delete a single product
                                  ],
                                ),
                              ),
                            ),
                          )),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
            width: 400,
            height: 50,
            child: Container(
              color: Colors.green,
              /*
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        /*
                        Navigator.of(contextSala).push(MaterialPageRoute(
                            builder: (context) => AddMision(
                              collectionReferenceMisiones:
                              collectionMisiones,
                              contextSala: contextSala,
                            )));
                         */
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
               */
            )));
  }
}

//Enviar solici

class enviarSolicitudeUsuario {
  static Future<Text> InterfaceEnviarSolicitud(BuildContext context,
      CollectionReference collectionReferenceUser, String idSala) async {
    var _userNameController = TextEditingController();
    return await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        "Enviar solicitud a usuario",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 90),
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
                TextField(
                  controller: _userNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de usuario'),
                ),
                const SizedBox(
                  height: 20,
                ),

                //Boton de enviar solicitud
                ElevatedButton(
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
                    child: Text('Enviar solicitud'))
              ],
            ),
          );
        });
  }

  //Metodo para ennviar solicitud de usuario

}
