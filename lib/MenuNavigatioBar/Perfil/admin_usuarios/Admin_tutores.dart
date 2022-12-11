import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../MediaQuery.dart';
import '../../../datos/CollecUsers.dart';
import '../../../datos/DatosPersonalUser.dart';
import '../../../datos/UsuarioActual.dart';
import '../AdminTutores.dart';
import '../cambiar_tutor_actual.dart';
import 'DejarTutoria.dart';

class UsuarioTutores {
  static var tutorActual;
  static Future setCurrentUser(initCurrenntTutor) async {
    CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .snapshots()
        .listen((event) {
      initCurrenntTutor(event['current_tutor']);
      tutorActual = event['current_tutor'];
    });
  }

  static getAllTutores() {
    return StreamBuilder(
        stream: CollecUser.COLECCION_USUARIOS
            .doc(CurrentUser.getIdCurrentUser())
            .collection('rolTutorado')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text("Algo ha ido mal");
          }

          if (snapshot.data?.docs.length == 0) {
            return Center(
              child: Text('Aún no tienes un tutor'),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: getCardUsuarioTutorado(
                        snapshot.data?.docs[index].id, context),
                  ),
                );
              },
            );
          } else {
            return Text('Aun no tienes un tutor');
          }
        });
  }

  static getCardUsuarioTutorado(String? idUsuario, BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        dense: true,
        /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
        leading: DatosPersonales.getAvatar(idUsuario!, 20),
        title: DatosPersonales.getDato(idUsuario, 'nombre'),
        subtitle: DatosPersonales.getDato(idUsuario, 'nombre_usuario'),
        trailing: SizedBox(
          height: Pantalla.getPorcentPanntalla(5, context, 'y'),
          width: Pantalla.getPorcentPanntalla(20, context, 'x'),
          child: Row(
            children: [marcarTutorActual(idUsuario), opciones(idUsuario)],
          ),
        ),
      ),
    );
  }

  static Widget marcarTutorActual(idUsuario) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      void initCurrentTutor(currentTutor) {
        setState(() {});
      }

      UsuarioTutores.setCurrentUser(initCurrentTutor);

      return tutorActual == idUsuario
          ? Icon(
              Icons.person_pin_rounded,
            )
          : Icon(
              Icons.person_pin_rounded,
              color: Colors.transparent,
            );
    });
  }

  static String _selectedMenu = '';
  static Widget opciones(String idTutor) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return PopupMenuButton<Menu>(

          // Callback that sets the selected popup menu item.
          onSelected: (Menu item) {
            setState(() {
              _selectedMenu = item.name;
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                PopupMenuItem<Menu>(
                  value: Menu.AddMision,
                  onTap: () => DejarTutoria.eliminarTutor(context, idTutor),
                  child: Text('Dejar tutoría'),
                ),
                PopupMenuItem<Menu>(
                  value: Menu.EliminarSala,
                  child: Text('Seleccionar tutoría'),
                  onTap: () => TutorActual.setNewActualTutor(idTutor),
                )
              ]);
    });
  }
}

enum Menu { AddMision, AddUsuario, EliminarSala }
