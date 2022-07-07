import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                    leading: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back) // the arrow back icon
                          ),
                    ),
                    title: const Center(
                      child: Text(
                        "Enviar solicitud a usuario",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ), // Your desired title
                    )),
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
                    onPressed: () {
                      enviarSolicitud(_userNameController.text,
                          collectionReferenceUser, idSala);
                    },
                    child: Text('Enviar solicitud'))
              ],
            ),
          );
        });
  }

  //Metodo para ennviar solicitud de usuario

  static Future<void> enviarSolicitud(String userName,
      CollectionReference collectionReferenceUsers, String idSala) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await collectionReferenceUsers
        .where('nombre_usuario', isEqualTo: userName)
        .get()
        .then((resultado) async => {
              if (resultado.docs.length == 1)
                {
                  await resultado.docs[0].reference
                      .collection('notificaciones')
                      .doc(resultado.docs[0].id)
                      .collection('solicitudes_recibidas')
                      .doc(idSala)
                      .set({
                    'id_emisor': auth.currentUser?.uid,
                    'id_sala': idSala,
                    'nombre_emisor': auth.currentUser?.displayName
                  }),
                }
              else
                {
                  print("el usuario especificado no existe")
                }
            });
  }
}
