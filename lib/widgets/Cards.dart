import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../Roll_Data.dart';
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
  static Widget getCardMision(
      String nombreMision,
      String objetivoMision,
      List<dynamic> completada_por,
      List<dynamic> solicitudeConf,
      String userId,
      BuildContext context,
      DocumentReference docMision,
      double Recompensa,
      dynamic puntos_total_de_usuario) {
    return Card(
      elevation: 0,
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        dense: true,
        onTap: () => print('object'),
        //horizontalTitleGap: -4,
        contentPadding: EdgeInsets.only(left: 15, top: 0, bottom: 10),
        /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
        title: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Row(children: [
            Text(nombreMision + ' ', style: GoogleFonts.roboto(fontSize: 20),),
            Icon(Icons.circle, size: 6,),
            Text(' ' + Recompensa.toString() + 'XP', style: GoogleFonts.roboto(color: Colors.amber, fontSize: 15))

          ],)

        ),
        subtitle: ReadMoreText(
          style: GoogleFonts.roboto(fontSize: 16),
          Text(
            objetivoMision,
            overflow: TextOverflow.ellipsis,
          ).data.toString(),
          trimLines: 1,
          colorClickableText: Colors.pink,
          trimMode: TrimMode.Line,
          lessStyle:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
          trimCollapsedText: 'ver más',
          trimExpandedText: 'ver menos',
          moreStyle: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 60,
          child: IconButton(
              icon: completada_por.contains(userId)
                  ? const Icon(
                      Icons.done,
                      size: 20,
                      color: Colors.green,
                    )
                  : solicitudeConf.contains(userId)
                      ? Icon(Icons.info)
                      : Icon(Icons.hourglass_top_rounded),
              onPressed: () => mostrarDialog(
                  context,
                  completada_por,
                  solicitudeConf,
                  userId,
                  nombreMision,
                  docMision,
                  Recompensa,
                  puntos_total_de_usuario)),
        ),
      ),
    );
  }

  //Acciones para el usuario tutor
  static mostrarDialog(
      BuildContext context,
      List completada_por,
      List solicitudeConf,
      String userId,
      String nombreMisoin,
      DocumentReference docMision,
      double recompensa,
      dynamic puntos_total_de_usuario) {
    if (completada_por.contains(userId)) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(nombreMisoin),
          content: Text('Esta misión ha sido realizada'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (solicitudeConf.contains(userId)) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(nombreMisoin),
          content: Text(!Roll_Data.ROLL_USER_IS_TUTORADO
              ? '¿La tarea ha sido completada?. \ No será posible deshacer el cambio'
              : 'Recibirás la recompensa de esta mision cuando tu tutor confirme que has realizado la tarea'),
          actions: <Widget>[
            !Roll_Data.ROLL_USER_IS_TUTORADO
                ? TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('no'),
                  )
                : TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('ok'),
                  ),
            !Roll_Data.ROLL_USER_IS_TUTORADO
                ? TextButton(
                    onPressed: () async {
                      await docMision.update({
                        'solicitu_confirmacion':
                            FieldValue.arrayRemove([userId])
                      }).then((value) async {
                        await docMision.update({
                          'completada_por': FieldValue.arrayUnion([userId])
                        }).then((value) async {
                          //Debe actualizar con el dato en tiempo real
                          await docMision.parent.parent?.parent.parent?.parent.doc(userId)
                              ?.collection('rolTutorado')
                              .doc(FirebaseAuth.instance.currentUser?.uid.trim())
                              .update({
                            'puntosTotal': puntos_total_de_usuario + recompensa
                          });
                        });
                      });
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('si'),
                  )
                : Text(''),
          ],
        ),
      );
    } else {
      if (Roll_Data.ROLL_USER_IS_TUTORADO) {
        //Solicitar confirmacion de mision
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(nombreMisoin),
            content: const Text(
                'Si has terminado esta tarea, envía una solicitud de verificacion, para recibir su recompensa'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('Cancelar')),
              TextButton(
                onPressed: () async {
                  await docMision.update({
                    'solicitu_confirmacion': FieldValue.arrayUnion([userId])
                  });
                  Navigator.pop(context, 'OK');
                },
                child: const Text('Enviar solicitud'),
              ),
            ],
          ),
        );
        return;
      }
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(nombreMisoin),
          content: const Text('Misión pendiente de realizar'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static Widget getCardMisionInicio(DocumentSnapshot documentSnapshot){
    return
      Card(

        elevation: 0,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 15, top: 0, bottom: 10),
          visualDensity: VisualDensity.comfortable,
          dense: true,
          onTap: () => print('object'),
          horizontalTitleGap: -4,
          /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
          title:
          Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(children: [
                Text(documentSnapshot['nombreMision'] + ' ', style: GoogleFonts.roboto(fontSize: 20),),
                Icon(Icons.circle, size: 6,),
                Text(' ' + documentSnapshot['recompensaMision'].toString() + 'XP', style: GoogleFonts.roboto(color: Colors.amber, fontSize: 15))

              ],)

          ),
          subtitle: ReadMoreText(
            Text(
              documentSnapshot['objetivoMision'],
              overflow: TextOverflow.ellipsis,
            ).data.toString(),
            style: GoogleFonts.roboto(fontSize: 16),
            trimLines: 1,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            lessStyle:
            GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
            trimCollapsedText: 'ver más',
            trimExpandedText: 'ver menos',
            moreStyle: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: SizedBox(
            width: 60,
            height: 26,
            child: IconButton(icon: Icon(Icons.more_vert,),
                onPressed: (){}),
          ),
        ),
      );

      Card(

      margin: const EdgeInsets.all(10),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
        //contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
        /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
        title: Text(Text(documentSnapshot['nombreMision'])
            .data
            .toString()),
        subtitle: ReadMoreText(
          Text(
            documentSnapshot['objetivoMision'],
            textAlign: TextAlign.justify,
          ).data.toString(),
          trimLines: 1,
          colorClickableText: Colors.pink,
          trimMode: TrimMode.Line,
          lessStyle: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.bold),
          trimCollapsedText: 'ver más',
          trimExpandedText: 'ver menos',
          moreStyle: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 30,
          child: IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () {}),
        ),
      ),
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
            ListaMisiones.ROUTE_NAME,
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
            TabPagesSala.ROUTE_NAME,
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
