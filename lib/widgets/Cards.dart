import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Servicios/Solicitudes/AdminSolicitudes.dart';
import '../datos/SalaDatos.dart';
import '../datos/TransferirDatos.dart';
import '../vista_tutor/TabPages/TaPagesSala.dart';
import '../vista_tutorado/Salas/ListaMisiones.dart';

class Cards {
  static Widget getCardSolicitud(
      DocumentSnapshot documentSnapshot,
      CollectionReference collectionReference,
      String? idCurrentUser,
      BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
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
                    title: Text(documentSnapshot['nombre_emisor'].toString()),
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
                                onPressed: () async =>
                                    Solicitudes.aceptarSolicitud(
                                        documentSnapshot['id_emisor'],
                                        documentSnapshot['id_sala'],
                                        collectionReference,
                                        idCurrentUser,
                                        context),
                                child: Text("Aceptar")),
                          )),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () async =>
                                Solicitudes.eliminarNotificacion(
                                    documentSnapshot['id_sala'],
                                    collectionReference,
                                    idCurrentUser,
                                    context,
                                    'rechazada'),
                            child: Text("Rechazar")),
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  //Cuerpo de las notificaciones sobre las misiones_________________________________________________________________
  static Widget cardNotificacionMisiones(DocumentSnapshot documentSnapshot) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.all(Colors.transparent)),
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
                      title: Text(documentSnapshot['nombre_sala'].toString()),
                      subtitle: Text(
                          documentSnapshot['nombre_tutor'].toString() +
                              " ha asignado una nueva misión"),
                      trailing: Icon(Icons.ac_unit),
                    ),
                  ],
                ),
              )),
        ));
  }

  //Terjeta de misiones
  static Widget getCardMision(String nombreMision, String objetivoMision,
      List<dynamic> completada_por, List<dynamic> solicitudeConf) {
    User? currentUser = FirebaseAuth.instance.currentUser;
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
            child: ListTile(
              /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
              title: Text(nombreMision),
              subtitle: Text(Text(objetivoMision).data.toString(),
                  overflow: TextOverflow.ellipsis, maxLines: 1),
              trailing: SizedBox(
                width: 60,
                child: Row(
                  children: [
                    IconButton(
                        icon: completada_por.contains(currentUser?.uid.trim())
                            ? Icon(Icons.done, size: 20)
                            : solicitudeConf.contains(currentUser?.uid.trim())
                                ? Icon(Icons.info)
                                : Icon(Icons.hourglass_top_rounded),
                        onPressed: () {}),
                    // Press this button to edit a single product
                    // This icon button is used to delete a single product
                  ],
                ),
              ),
            ),
          )),
    );
  }

  //Aspecto que tendrán las salas para los usuario tutorados
  static Widget CardSalaVistaTutorado(
      BuildContext context,
      CollectionReference collecionUsuarios,
      DocumentSnapshot documentSnapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: FlatButton(
        color: Colors.transparent,
        splashColor: Colors.black26,

        //pasar datos de la sala pulzada a la siguiente ventana
        onPressed: () {
          //Crea un objeto con la sala pulzada para posteriormente obtener su contenido midiante geters en la siguiente ventana
          SalaDatos sala = SalaDatos(documentSnapshot.reference);

          Navigator.pushNamed(
            context,
            ListaMisiones.routeName,
            arguments: TransferirDatos(
                Text(documentSnapshot['NombreSala'])
                    .data
                    .toString(), //Nombre de la sala pulsada
                sala,
                collecionUsuarios),
          );

          //this.titulo = 'holaaa';

          //Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuSala()) );
        },
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            //margin: EdgeInsets.all(13),
            elevation: 1,

            // Dentro de esta propiedad usamos ClipRRect
            child: ClipRRect(
              // Los bordes del contenido del card se cortan usando BorderRadius
              borderRadius: BorderRadius.circular(2),
              // EL widget hijo que será recortado segun la propiedad anterior
              child: Column(
                children: <Widget>[
                  //Se mmuestra la imagen con un tamaño fijo
                  Container(
                    height: 120,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2), BlendMode.dstATop),
                          image: const AssetImage('img/default.jpg')),
                    ),
                  ),

                  // Usamos Container para el contenedor de la descripción
                  Container(
                    color: Colors.blue,
                    child: ListTile(
                      title: Text(
                          Text(documentSnapshot['NombreSala']).data.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      trailing: SizedBox(
                        width: 130,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Icon(Icons.done, size: 18),
                            ),
                            Text(documentSnapshot['numTutorados'].toString(),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.right),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.hourglass_top, size: 18),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Text(
                                documentSnapshot['numMisiones'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.info, size: 18),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Text(
                                0.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  //Tarjeta sala para la vista del tutor_________________________________________________________________________
  static Widget vistaTutor(BuildContext context,
      CollectionReference collecionUsuarios, documentSnapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: FlatButton(
        color: Colors.transparent,
        splashColor: Colors.black26,

        //pasar datos de la sala pulzada a la siguiente ventana
        onPressed: () {
          //Crea un objeto con la sala pulzada para posteriormente obtener su contenido midiante geters en la siguiente ventana
          SalaDatos sala = SalaDatos(documentSnapshot.reference);

          Navigator.pushNamed(
            context,
            TabPagesSala.routeName,
            arguments: TransferirDatos(
                Text(documentSnapshot['NombreSala'])
                    .data
                    .toString(), //Nombre de la sala pulsada
                sala,
                collecionUsuarios),
          );

          //this.titulo = 'holaaa';

          //Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuSala()) );
        },
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            //margin: EdgeInsets.all(13),
            elevation: 1,

            // Dentro de esta propiedad usamos ClipRRect
            child: ClipRRect(
              // Los bordes del contenido del card se cortan usando BorderRadius
              borderRadius: BorderRadius.circular(2),
              // EL widget hijo que será recortado segun la propiedad anterior
              child: Column(
                children: <Widget>[
                  //Se mmuestra la imagen con un tamaño fijo
                  Container(
                    height: 120,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2), BlendMode.dstATop),
                          image: AssetImage('img/default.jpg')),
                    ),
                  ),

                  // Usamos Container para el contenedor de la descripción
                  Container(
                    color: Colors.blue,
                    child: ListTile(
                      title: Text(
                          Text(documentSnapshot['NombreSala']).data.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      trailing: SizedBox(
                        width: 70,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child:
                                  Icon(Icons.supervised_user_circle, size: 18),
                            ),
                            Text(documentSnapshot['numTutorados'].toString(),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.right),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.flag, size: 18),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Text(
                                documentSnapshot['numMisiones'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
