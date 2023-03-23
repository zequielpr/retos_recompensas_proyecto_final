import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/AdminSala.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/recursos/DateActual.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../recursos/Colores.dart';
import '../Servicios/Notificaciones/AntiguedadNotificacion.dart';
import '../Servicios/Notificaciones/NotiSolicitudConfirmacion.dart';
import '../datos/DatosPersonalUser.dart';
import '../datos/Roll_Data.dart';
import '../Servicios/Solicitudes/AdminSolicitudes.dart';
import '../datos/SalaDatos.dart';
import '../datos/TransferirDatos.dart';
import '../datos/UsuarioActual.dart';

class Cards {
  static Widget getStadoSolicitud(DocumentSnapshot documentSnapshot,
      BuildContext context, AppLocalizations? valores) {
    DateActual.getActualDateTime();
    bool isTutorado = Roll_Data.ROLL_USER_IS_TUTORADO;
    String subtitle = '';
    Color color = Colors.transparent;
    var stado = documentSnapshot['estado'];

    Timestamp fecha_solicitu = documentSnapshot['fecha_actual'];

    var unidadTiempo =
        AntiguedadNotificaciones.getAntiguedad(fecha_solicitu, valores);
    late Widget trailain;
    switch (stado) {
      case 0:
        color = Colors.transparent;
        trailain = Icon(Icons.access_time_outlined);
        subtitle = '${valores?.solicitude_env_hace}  $unidadTiempo';
        break;
      case 1:
        color = Color.fromARGB(200, 105, 240, 174);
        trailain = Icon(
          Icons.check,
          color: color,
        );
        subtitle = '${valores?.soicitude_acept_hace} $unidadTiempo';
        break;
      case 2:
        color = Color.fromARGB(200, 255, 32, 32);
        trailain = Icon(
          Icons.cancel_outlined,
          color: color,
        );
        subtitle = '${valores?.solicitud_rechazada_hace} $unidadTiempo';
        break;
    }

    Widget miniatura = DatosPersonales.getAvatar(
        isTutorado
            ? documentSnapshot['id_emisor']
            : documentSnapshot['id_destinatario'],
        20);

    Widget nombre = DatosPersonales.getDato(
        isTutorado
            ? documentSnapshot['id_emisor']
            : documentSnapshot['id_destinatario'],
        'nombre_usuario',
        TextStyle());

    return Card(
      shape: Border(),
      margin: EdgeInsets.all(0),
      elevation: 0,
      child: ListTile(
        leading: miniatura,
        title: nombre,
        subtitle: Text(subtitle),
        trailing: trailain,
      ),
    );
  }

  static Widget getCardSolicitud(
      DocumentSnapshot documentSnapshot,
      CollectionReference collectionReference,
      String? idCurrentUser,
      BuildContext context,
      AppLocalizations? valores) {
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
                        documentSnapshot['id_emisor'], 20),
                    title: Text(documentSnapshot['nombre_emisor'].toString()),
                    subtitle: Text(
                        documentSnapshot['nombre_emisor'].toString() +
                            " ${valores?.desea_unir_tutoria}"),
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
                                        documentSnapshot,
                                        collectionReference,
                                        idCurrentUser,
                                        context),
                                child: Text("${valores?.aceptar}")),
                          )),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () async =>
                                Solicitudes.cambiarStatdoSolicitud(
                                    documentSnapshot, 2),
                            child: Text("${valores?.rechazar}")),
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  //Cuerpo de las notificaciones sobre las misiones_________________________________________________________________
  static Widget cardNotificacionMisiones(DocumentSnapshot documentSnapshot,
      BuildContext context, AppLocalizations? valores) {
    DateActual.getActualDateTime();

    Timestamp fecha_solicitu = documentSnapshot['fecha_actual'];

    var unidadTiempo =
        AntiguedadNotificaciones.getAntiguedad(fecha_solicitu, valores);

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
              title: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                text: TextSpan(children: [
                  TextSpan(
                      text: documentSnapshot['nombre_tutor'],
                      style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                  TextSpan(
                    text:
                        ': ${valores?.recibe} ${documentSnapshot['recompensa'].toString()}xp ${valores?.por} ',
                  ),
                  TextSpan(
                    text:
                        '${documentSnapshot['nombre_mision'].toString()} ${valores?.en} ',
                  ),
                  TextSpan(
                    text: documentSnapshot['nombre_sala'].toString(),
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                  ),
                ], style: GoogleFonts.roboto(color: Colors.black)),
              ),
              subtitle: Text("$unidadTiempo"),
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
      DocumentSnapshot documentSnapshot,
      String userId,
      BuildContext context,
      AppLocalizations? valores,
      String nombreSala, puntos_total_de_usuario) {
    String nombreMision = documentSnapshot['nombreMision'];
    String objetivoMision = documentSnapshot['objetivoMision'];
    List<dynamic> completada_por = documentSnapshot['completada_por'];
    List<dynamic> solicitudeConf = documentSnapshot['solicitu_confirmacion'];
    DocumentReference docMision = documentSnapshot.reference;
    double Recompensa = documentSnapshot['recompensaMision'];



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
          trimCollapsedText: '${valores?.ver_mas}',
          trimExpandedText: '${valores?.ver_menos}',
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
                  puntos_total_de_usuario,
                  valores,
                  nombreSala)),
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
    dynamic puntos_total_de_usuario,
    AppLocalizations? valores,
    String nombreSala,
  ) {
    if (completada_por.contains(userId)) {
      getDialogMisionRealizada(context, nombreMision, valores);
    } else if (solicitudeConf.contains(userId)) {
      getDialogPendienteConfirmacion(context, nombreMision, docMision, userId,
          puntos_total_de_usuario, recompensa, valores);
    } else {
      if (Roll_Data.ROLL_USER_IS_TUTORADO) {
        //Solicitar confirmacion de mision11
        getDialogSolicitud(
            context, nombreMision, docMision, userId, valores, nombreSala);
        return;
      }
      String titulo = nombreMision;
      String mensaje = '${valores?.mision_pendiente_realizar}';

      actions(BuildContext context) {
        return <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('${valores?.ok}'),
          ),
        ];
      }

      Dialogos.mostrarDialog(actions, titulo, mensaje, context);
    }
  }

  //Dialogs_____________________________________________________-
  static void getDialogMisionRealizada(
      BuildContext context, nombreMision, AppLocalizations? valores) {
    String titulo = nombreMision;
    String mensaje = '${valores?.esta_misions_realizada}';
    actions(BuildContext context) {
      return <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text('${valores?.ok}'),
        ),
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static void getDialogPendienteConfirmacion(context, nombreMision, docMision,
      userId, puntos_total_de_usuario, recompensa, AppLocalizations? valores) {
    //Añadir recompensa sobrante
    GuardarRecompensaSobrante(recompensa) async {
      await Coleciones.COLECCION_USUARIOS
          .doc(userId)
          .collection('rolTutorado')
          .doc(CurrentUser.getIdCurrentUser())
          .update({'puntos_acumulados': FieldValue.increment(recompensa)});
      return;
    }

    addRecompensa(recompensa) async {
      await Coleciones.COLECCION_USUARIOS
          .doc(userId)
          .collection('rolTutorado')
          .doc(CurrentUser.getIdCurrentUser())
          .update({'puntosTotal': FieldValue.increment(recompensa)});
      return;
    }

    String mensaje = !Roll_Data.ROLL_USER_IS_TUTORADO
        ? '${valores?.mision_realizada_question}'
        : '${valores?.confirmacion_pendiente}';
    String titulo = nombreMision;
    actions(BuildContext context) {
      return <Widget>[
        !Roll_Data.ROLL_USER_IS_TUTORADO
            ? TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('${valores?.no}'),
              )
            : TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('${valores?.ok}'),
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
                  Navigator.pop(context, '${valores?.ok}');
                },
                child: Text('${valores?.si}'),
              )
            : Text(''),
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static void getDialogSolicitud(context, nombreMision, docMision, userId,
      AppLocalizations? valores, String nombreSala) {
    String mensaje = '${valores?.enviar_solicitud_confirmacion}';
    String titulo = nombreMision;
    actions(BuildContext context) {
      return <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('${valores?.cancelar}')),
        TextButton(
          onPressed: () async {
            await docMision.update({
              'solicitu_confirmacion': FieldValue.arrayUnion([userId])
            });
            await NotiSolicitudConfirmacion.setNotiSolicitudNotificacion(
                nombreMision, nombreSala);
            Navigator.pop(context, 'OK');
          },
          child: Text('${valores?.enviar}'),
        ),
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static Widget getCardMisionInicio(DocumentSnapshot documentSnapshot,
      BuildContext context, AppLocalizations? valores) {
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
          trimCollapsedText: valores?.ver_mas as String,
          trimExpandedText: ' ${valores?.ver_menos}',
          moreStyle:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: Pantalla.getPorcentPanntalla(16, context, 'x'),
          height: Pantalla.getPorcentPanntalla(
              Pantalla.getPorcentPanntalla(0.6, context, 'y'), context, 'y'),
          child: IconButton(
            tooltip: valores?.eliminar,
            splashRadius: 0.1,
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () async => await AdminSala.eliminarMision(
                idSala, idMision, context, valores), //Eliminar mision
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

  //Cuerpo de las notificaciones sobre las misiones_________________________________________________________________
  static Widget cardNotiSolicitudMision(DocumentSnapshot documentSnapshot,
      BuildContext context, AppLocalizations? valores) {
    DateActual.getActualDateTime();

    Timestamp fecha_solicitu = documentSnapshot['fecha_actual'];

    var unidadTiempo =
        AntiguedadNotificaciones.getAntiguedad(fecha_solicitu, valores);

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
              title: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                text: TextSpan(children: [
                  TextSpan(
                      text: documentSnapshot['nombre_tutorado'],
                      style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                  TextSpan(
                    text:
                        ': ${valores?.confirmar} ${documentSnapshot['nombre_mision'].toString()} ${valores?.en}',
                  ),
                  TextSpan(
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                    text:
                        ' ${documentSnapshot['nombre_sala'].toString()}',
                  ),
                ], style: GoogleFonts.roboto(color: Colors.black)),
              ),
              subtitle: Text("$unidadTiempo"),
              leading:
                  DatosPersonales.getAvatar(documentSnapshot['id_emisor'], 20),
            ),
          ],
        ),
      ),
    );
  }
}
