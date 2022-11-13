import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/AdminSala.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

import '../datos/DatosPersonalUser.dart';
import '../datos/Roll_Data.dart';
import '../Servicios/Solicitudes/AdminSolicitudes.dart';
import '../datos/SalaDatos.dart';
import '../datos/TransferirDatos.dart';
import '../datos/UsuarioActual.dart';

class Cards {
  static Widget getCardSolicitud(
      DocumentSnapshot documentSnapshot,
      CollectionReference collectionReference,
      String? idCurrentUser,
      BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
        child: Card(
            color: Colors.transparent,
            elevation: 0,
            child: SizedBox(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    leading: DatosPersonales.getAvatar(
                        CollecUser.COLECCION_USUARIOS,
                        documentSnapshot['id_emisor'],
                        25),
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
  static Widget cardNotificacionMisiones(
      DocumentSnapshot documentSnapshot, BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
              onTap: () {
                context.router.push(Mision(snap: documentSnapshot));
              },
              /*
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4U5WnC1MCC0IFVbJPePBA2H0oEep5aDR_xS_FbNx3wlqqORv2QRsf5L5fbwOZBeqMdl4&usqp=CAU"),
                                ),
                                 */
              title: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                text: TextSpan(children: [
                  TextSpan(
                      text: documentSnapshot['nombre_tutor'],
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: ' Ha asignado una nueva tarea en la sala ',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(
                    text: documentSnapshot['nombre_sala'].toString() + ': ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: documentSnapshot['nombre_mision'].toString(),
                    style: TextStyle(),
                  )
                ], style: TextStyle(color: Colors.black)),
              ),
              leading: DatosPersonales.getAvatar(CollecUser.COLECCION_USUARIOS,
                  documentSnapshot['id_emisor'], 20),
            ),
          ],
        ),
      ),
    );
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
        //horizontalTitleGap: -4,
        contentPadding: EdgeInsets.only(left: 15, top: 0, bottom: 10),
        /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
        title: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Text(
                  nombreMision + ' ',
                  style: GoogleFonts.roboto(fontSize: 20),
                ),
                Icon(
                  Icons.circle,
                  size: 6,
                ),
                Text(' ' + Recompensa.toString() + 'XP',
                    style:
                        GoogleFonts.roboto(color: Colors.amber, fontSize: 15))
              ],
            )),
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
          moreStyle:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
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
      String nombreMision,
      DocumentReference docMision,
      double recompensa,
      dynamic puntos_total_de_usuario) {
    if (completada_por.contains(userId)) {
      getDialogMisionRealizada(context, nombreMision);
    } else if (solicitudeConf.contains(userId)) {
      getDialogPendienteConfirmacion(context, nombreMision, docMision, userId,
          puntos_total_de_usuario, recompensa);
    } else {
      if (Roll_Data.ROLL_USER_IS_TUTORADO) {
        //Solicitar confirmacion de mision11
        getDialogSolicitud(context, nombreMision, docMision, userId);
        return;
      }
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(nombreMision)],
          ),
          titlePadding: EdgeInsets.only(
              top: Pantalla.getPorcentPanntalla(2, context, 'y'),
              bottom: Pantalla.getPorcentPanntalla(1, context, 'y')),
          contentPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(0),
          actionsAlignment: MainAxisAlignment.center,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Misión pendiente de realizar')],
          ),
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

  //Dialogs_____________________________________________________-
  static void getDialogMisionRealizada(BuildContext context, nombreMision) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(nombreMision)],
        ),
        titlePadding: EdgeInsets.only(
            top: Pantalla.getPorcentPanntalla(2, context, 'y'),
            bottom: Pantalla.getPorcentPanntalla(1, context, 'y')),
        contentPadding: EdgeInsets.all(0),
        actionsPadding: EdgeInsets.all(0),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Esta misión ha sido realizada')],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void getDialogPendienteConfirmacion(context, nombreMision, docMision,
      userId, puntos_total_de_usuario, recompensa) {
    //Añadir recompensa sobrante
    GuardarRecompensaSobrante(recompensa) async {
      await docMision.parent.parent?.parent.parent?.parent
          .doc(userId)
          ?.collection('rolTutorado')
          .doc(CurrentUser.getIdCurrentUser())
          .update({'puntos_acumulados': FieldValue.increment(recompensa)});
      return;
    }

    addRecompensa(recompensa) async {
      await CollecUser.COLECCION_USUARIOS
          .doc(userId)
          .collection('rolTutorado')
          .doc(CurrentUser.getIdCurrentUser())
          .update({'puntosTotal': FieldValue.increment(recompensa)});
      return;
    }

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(nombreMision)],
        ),
        titlePadding: EdgeInsets.only(
            top: Pantalla.getPorcentPanntalla(2, context, 'y'),
            bottom: Pantalla.getPorcentPanntalla(1, context, 'y')),
        contentPadding: EdgeInsets.all(0),
        actionsPadding: EdgeInsets.all(0),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(!Roll_Data.ROLL_USER_IS_TUTORADO
                ? '¿La tarea ha sido completada?'
                : 'Confirmacion pendiente')
          ],
        ),
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
                      'solicitu_confirmacion': FieldValue.arrayRemove([userId])
                    }).then((value) async {
                      await docMision.update({
                        'completada_por': FieldValue.arrayUnion([userId])
                      }).then((value) async {
                        //Debe actualizar con el dato en tiempo real
                        if (puntos_total_de_usuario + recompensa <= 200) {
                          addRecompensa(recompensa);
                          return;
                        } else if (puntos_total_de_usuario == 200) {
                          GuardarRecompensaSobrante(recompensa);
                          return;
                        }
                        var recompensaMaxima = 200;
                        //Puntos sobrantes de la recompensa maxima
                        var sobrante = (puntos_total_de_usuario + recompensa) -
                            recompensaMaxima;
                        print('Sobrante $sobrante');
                        //Añade los puntos necesarios para la recompensa maxima
                        addRecompensa(recompensa - sobrante);
                        //Guarda la recompensa sobrante
                        GuardarRecompensaSobrante(sobrante);

                        return;
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
  }

  static void getDialogSolicitud(context, nombreMision, docMision, userId) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(nombreMision)],
        ),
        titlePadding: EdgeInsets.only(
            top: Pantalla.getPorcentPanntalla(2, context, 'y'),
            bottom: Pantalla.getPorcentPanntalla(1, context, 'y')),
        contentPadding: EdgeInsets.all(0),
        actionsPadding: EdgeInsets.all(0),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('¿Enviar un solicitud de confirmacion?')],
        ),
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
  }

  static Widget getCardMisionInicio(
      DocumentSnapshot documentSnapshot, BuildContext context) {
    String? idSala = documentSnapshot.reference.parent.parent?.id;
    String idMision = documentSnapshot.id;
    return Card(
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
        title: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Text(
                  documentSnapshot['nombreMision'] + ' ',
                  style: GoogleFonts.roboto(fontSize: 20),
                ),
                Icon(
                  Icons.circle,
                  size: 6,
                ),
                Text(
                    ' ' +
                        documentSnapshot['recompensaMision'].toString() +
                        'XP',
                    style:
                        GoogleFonts.roboto(color: Colors.amber, fontSize: 15))
              ],
            )),
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
          moreStyle:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 60,
          height: Pantalla.getPorcentPanntalla(5, context, 'y'),
          child: IconButton(
            tooltip: 'Eliminar',
            splashRadius: 0.1,
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () async => await AdminSala.eliminarMision(idSala, idMision, context), //Eliminar mision
          ),
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

          var datos = TransferirDatos(
              Text(documentSnapshot['NombreSala'])
                  .data
                  .toString(), //Nombre de la sala pulsada
              sala,
              collecionUsuarios);

          context.router.push(ListMisionesTutorado(args: datos));

          //this.titulo = 'holaaa';

          //Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuSala()) );
        },
        child: vistaCardSala(context, documentSnapshot['NombreSala']),
      ),
    );
  }

  //Tarjeta sala para la vista del tutor_________________________________________________________________________
  static Widget vistaTutor(BuildContext context,
      CollectionReference collecionUsuarios, documentSnapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),

          //Long press para seleccionar
          onLongPress: () {},

          //pasar datos de la sala pulzada a la siguiente ventana
          onPressed: () {
            //Crea un objeto con la sala pulzada para posteriormente obtener su contenido midiante geters en la siguiente ventana
            SalaDatos sala = SalaDatos(documentSnapshot.reference);

            var datos = TransferirDatos(
                Text(documentSnapshot['NombreSala'])
                    .data
                    .toString(), //Nombre de la sala pulsada
                sala,
                collecionUsuarios);

            context.router.push(SalaContVistaTutor(args: datos));
            //this.titulo = 'holaaa';

            //Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuSala()) );
          },
          child: vistaCardSala(context, documentSnapshot['NombreSala'])),
    );
  }

  static Widget vistaCardSala(BuildContext context, String nombreSala) {
    return Card(
      color: Colors.orange,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SizedBox(
        width: 300,
        height: 100,
        child: Center(
            child: Text(
          nombreSala,
          style: TextStyle(fontSize: 35),
        )),
      ),
    );
  }
}
