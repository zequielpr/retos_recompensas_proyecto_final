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
import 'package:retos_proyecto/recursos/Espacios.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../Colores.dart';
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
                        documentSnapshot['id_emisor'], 25),
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
                                    await Solicitudes.aceptarSolicitud(
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
                                    'Solicitud rechazada correctamente'),
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
    var leftRight =
        Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  EdgeInsets.only(left: leftRight, right: leftRight),
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
                      style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: ': recibe ${documentSnapshot['recompensa'].toString()} por ',),
                  TextSpan(
                    text: '${documentSnapshot['nombre_mision'].toString()} en la sala ',
                  ),
                  TextSpan(
                    text: documentSnapshot['nombre_sala'].toString(),
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                  ),

                ], style: GoogleFonts.roboto(color: Colors.black)),
              ),
              leading:
                  DatosPersonales.getAvatar(documentSnapshot['id_emisor'], 20),
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
      margin: EdgeInsets.only(
          left: Pantalla.getPorcentPanntalla(4, context, 'x'),
          right: Pantalla.getPorcentPanntalla(4, context, 'x'),
          top: Pantalla.getPorcentPanntalla(4, context, 'x')),
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        dense: true,
        //horizontalTitleGap: -4,
        contentPadding: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(4, context, 'x'),
            bottom: Pantalla.getPorcentPanntalla(1, context, 'y')),
        /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
        title: Padding(
            padding: EdgeInsets.only(
                bottom: Pantalla.getPorcentPanntalla(1, context, 'y')),
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
          width: Pantalla.getPorcentPanntalla(16, context, 'x'),
          height: Pantalla.getPorcentPanntalla(
              Pantalla.getPorcentPanntalla(0.6, context, 'y'), context, 'y'),
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
      String titulo = nombreMision;
      String mensaje = 'Misión pendiente de realizar';

      actions(BuildContext context) {
        return <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ];
      }

      Dialogos.mostrarDialog(actions, titulo, mensaje, context);
    }
  }

  //Dialogs_____________________________________________________-
  static void getDialogMisionRealizada(BuildContext context, nombreMision) {
    String titulo = nombreMision;
    String mensaje = 'Esta misión ha sido realizada';
    actions(BuildContext context) {
      return <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static void getDialogPendienteConfirmacion(context, nombreMision, docMision,
      userId, puntos_total_de_usuario, recompensa) {
    //Añadir recompensa sobrante
    GuardarRecompensaSobrante(recompensa) async {
      await CollecUser.COLECCION_USUARIOS
          .doc(userId)
          .collection('rolTutorado')
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

    String mensaje = !Roll_Data.ROLL_USER_IS_TUTORADO
        ? '¿La tarea ha sido completada?'
        : 'Confirmacion pendiente';
    String titulo = nombreMision;
    actions(BuildContext context) {
      return <Widget>[
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
                        await GuardarRecompensaSobrante(recompensa);
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
                      await GuardarRecompensaSobrante(sobrante);

                      return;
                    });
                  });
                  Navigator.pop(context, 'OK');
                },
                child: const Text('si'),
              )
            : Text(''),
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static void getDialogSolicitud(context, nombreMision, docMision, userId) {
    String mensaje = '¿Enviar un solicitud de confirmacion?';
    String titulo = nombreMision;
    actions(BuildContext context) {
      return <Widget>[
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
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static Widget getCardMisionInicio(
      DocumentSnapshot documentSnapshot, BuildContext context) {
    String? idSala = documentSnapshot.reference.parent.parent?.id;
    String idMision = documentSnapshot.id;
    return Card(
      margin: EdgeInsets.only(
          left: Pantalla.getPorcentPanntalla(4, context, 'x'),
          right: Pantalla.getPorcentPanntalla(4, context, 'x'),
          top: Pantalla.getPorcentPanntalla(4, context, 'x')),
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(4, context, 'x'),
            bottom: Pantalla.getPorcentPanntalla(1, context, 'y')),
        visualDensity: VisualDensity.comfortable,
        dense: true,
        onTap: () => print('object'),
        horizontalTitleGap: -4,
        /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
        title: Padding(
            padding: EdgeInsets.only(
                bottom: Pantalla.getPorcentPanntalla(1, context, 'y')),
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
          trimMode: TrimMode.Line,
          lessStyle:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
          trimCollapsedText: 'ver más',
          trimExpandedText: ' ver menos',
          moreStyle:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: Pantalla.getPorcentPanntalla(16, context, 'x'),
          height: Pantalla.getPorcentPanntalla(
              Pantalla.getPorcentPanntalla(0.6, context, 'y'), context, 'y'),
          child: IconButton(
            tooltip: 'Eliminar',
            splashRadius: 0.1,
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () async => await AdminSala.eliminarMision(
                idSala, idMision, context), //Eliminar mision
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
      padding: EdgeInsets.only(
          top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y')),
      child: FlatButton(
        color: Colors.transparent,
        splashColor: Colors.black26,

        //pasar datos de la sala pulzada a la siguiente ventana
        onPressed: () {
          //Crea un objeto con la sala pulzada para posteriormente obtener su contenido midiante geters en la siguiente ventana
          SalaDatos sala = SalaDatos(documentSnapshot.reference, '');

          var datos = TransferirDatos(
              Text(documentSnapshot['NombreSala'])
                  .data
                  .toString(), //Nombre de la sala pulsada
              sala);

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
      padding: EdgeInsets.only(
          top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y')),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),

          //Long press para seleccionar
          onLongPress: () {},

          //pasar datos de la sala pulzada a la siguiente ventana
          onPressed: () {
            //Crea un objeto con la sala pulzada para posteriormente obtener su contenido midiante geters en la siguiente ventana
            SalaDatos sala = SalaDatos(documentSnapshot.reference, '');

            var datos = TransferirDatos(
                Text(documentSnapshot['NombreSala'])
                    .data
                    .toString(), //Nombre de la sala pulsada
                sala);

            context.router.push(SalaContVistaTutor(args: datos));
            //this.titulo = 'holaaa';

            //Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuSala()) );
          },
          child: vistaCardSala(context, documentSnapshot['NombreSala'])),
    );
  }

  static Widget vistaCardSala(BuildContext context, String nombreSala) {
    return Card(
      color: Colores.colorPrincipal,
      elevation: 0,
      shape: RoundedRectangleBorder(
        /*side: BorderSide(
          color: Color.fromARGB(100, 0, 0, 0),
        ),*/
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SizedBox(
        width: Pantalla.getPorcentPanntalla(90, context, 'x'),
        height: Pantalla.getPorcentPanntalla(13, context, 'y'),
        child: Center(
            child: Text(
          nombreSala,
          style: TextStyle(
              fontSize: 35, color: Color.fromARGB(255, 255, 255, 255)),
        )),
      ),
    );
  }
}
