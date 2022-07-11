import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/splashScreen.dart';

import '../Solicitudes/AdminSolicitudes.dart';

/*
class Notificacion_Bandeja {
 static  FirebaseAuth auth = FirebaseAuth.instance;
  static Widget getBodyAppVarBandejaNotifi(CollectionReference collectionReference) {
    CollectionReference notificacionesRecibidas = collectionReference.doc(auth.currentUser?.uid).
    collection('solicitudes').doc('gHwRFSgb0qIkVSyQCMuO').collection('solicitudes_recibidas');
    return StreamBuilder(
      stream: notificacionesRecibidas.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
              streamSnapshot.data!.docs[index];
              return
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
                    child: Card(
                        elevation: 1,
                        child: SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                               ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4U5WnC1MCC0IFVbJPePBA2H0oEep5aDR_xS_FbNx3wlqqORv2QRsf5L5fbwOZBeqMdl4&usqp=CAU"),
                                ),
                                title: Text(documentSnapshot['nombre_emisor'].toString()),
                                subtitle: Text( documentSnapshot['nombre_emisor'].toString() + " Zequiel desea que te unas a su tutoría"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 25),
                                      child: SizedBox(
                                        height: 30,
                                        width: 100,
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text("Confirmar")),
                                      )),
                                  SizedBox(
                                    height: 30,
                                    width: 100,
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Aliminar")),
                                  )
                                ],
                              )
                            ],
                          ),
                        ))
                );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

  }

  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Row(children: [
              InkWell(

                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back) // the arrow back icon
              ),
              Padding(padding: EdgeInsets.only(left: 20), child: Text("Notificaciones"))
            ],),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Misiones",),
                Tab(text: "Solicitudes",),
              ],
            ),


          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
  */
}
 */

//Nueva bandeja de notificaciones---------------------------------------------------------------------------------
class bandejaNotificaciones {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? currentUser = auth.currentUser;

  static Widget getBandejaNotificaciones(
      CollectionReference collectionReference, BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Misiones',
              ),
              Tab(
                text: 'Solicitudes',
              ),
            ],
          ),
          toolbarHeight: 2,
        ),
        body: TabBarView(
          children: [
            getMisiones(collectionReference),
            getSolicitudesRecibidas(collectionReference, context),
          ],
        ),
      ),
    );
  }

  //Obtener las solicitudes recibidas------------------------------------------------------------------
  static Widget getSolicitudesRecibidas(
      CollectionReference collectionReference, BuildContext context) {
    CollectionReference notificacionesRecibidas = collectionReference
        .doc(currentUser?.uid)
        .collection('notificaciones')
        .doc(currentUser?.uid)
        .collection('solicitudesRecibidas');
    return StreamBuilder(
      stream: notificacionesRecibidas.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
                  child: Card(
                      elevation: 1,
                      child: SizedBox(
                        height: 120,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4U5WnC1MCC0IFVbJPePBA2H0oEep5aDR_xS_FbNx3wlqqORv2QRsf5L5fbwOZBeqMdl4&usqp=CAU"),
                              ),
                              title: Text(
                                  documentSnapshot['nombre_emisor'].toString()),
                              subtitle: Text(
                                  documentSnapshot['nombre_emisor'].toString() +
                                      " desea que te unas a su tutoría"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(right: 25),
                                    child: SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: ElevatedButton(
                                          onPressed: () async => Solicitudes.aceptarSolicitud(documentSnapshot['id_emisor'],
                                              documentSnapshot['id_sala'], collectionReference, currentUser, context),
                                          child: Text("Aceptar")),
                                    )),
                                SizedBox(
                                  height: 30,
                                  width: 100,
                                  child: ElevatedButton(
                                      onPressed: () async => Solicitudes.eliminarNotificacion(documentSnapshot['id_sala'], collectionReference, currentUser, context, 'rechazada'),
                                      child: Text("Rechazar")),
                                )
                              ],
                            )
                          ],
                        ),
                      )));
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  //Obtener las misiones recibidas------------------------------------------------------------------
  static Widget getMisiones(CollectionReference collectionReference) {
    CollectionReference notificacionesRecibidas = collectionReference
        .doc(auth.currentUser?.uid)
        .collection('notificaciones')
        .doc(auth.currentUser?.uid)
        .collection('misiones_recibidas');
    return StreamBuilder(
      stream: notificacionesRecibidas.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () {
                      print("se ha pulsado la misión");
                    },
                    child: Card(
                        elevation: 1,
                        child: SizedBox(
                          child: Column(
                            children: [
                              ListTile(
                                /*
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4U5WnC1MCC0IFVbJPePBA2H0oEep5aDR_xS_FbNx3wlqqORv2QRsf5L5fbwOZBeqMdl4&usqp=CAU"),
                                ),
                                 */
                                title: Text(
                                    documentSnapshot['nombre_sala'].toString()),
                                subtitle: Text(documentSnapshot['nombre_tutor']
                                        .toString() +
                                    " ha asignado una nueva misión"),
                                trailing: Icon(Icons.ac_unit),
                              ),
                            ],
                          ),
                        )),
                  ));
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
