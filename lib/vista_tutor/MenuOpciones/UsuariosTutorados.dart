
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../datos/SalaDatos.dart';

class Usuarios extends StatelessWidget {
  final CollectionReference  collectionReferenceUsuariosTutorados;
  final CollectionReference collectionReferenceUsuariosDocPersonal;
  Usuarios( {Key? key, required this.collectionReferenceUsuariosTutorados, required this.collectionReferenceUsuariosDocPersonal}) : super(key: key);


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
                    return
                      Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child:
                      FlatButton(
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
                          child:Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 1,
                            child:ListTile(
                              leading: CircleAvatar(backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4U5WnC1MCC0IFVbJPePBA2H0oEep5aDR_xS_FbNx3wlqqORv2QRsf5L5fbwOZBeqMdl4&usqp=CAU"),),
                              title: SalaDatos.getNombreUsuario(collectionReferenceUsuariosDocPersonal, documentSnapshot.id),
                              subtitle: Text(documentSnapshot['puntosTotal'].toString() + ' xp',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.visibility, size: 20),
                                        onPressed: () {}),
                                    // Press this button to edit a single product

                                    IconButton(
                                      icon: const Icon(Icons.exit_to_app_outlined, color: Colors.red, size: 20),
                                      onPressed: ()=>showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          title: const Text('Expulsar usuario'),
                                          content: const Text('Al expulsar este usuario se perderán los logros conseguidos en esta sala'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: (){
                                                print('no');
                                                Navigator.pop(context, 'Cancel');
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
                          )
                      ),);
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
      ),
    );
  }
}