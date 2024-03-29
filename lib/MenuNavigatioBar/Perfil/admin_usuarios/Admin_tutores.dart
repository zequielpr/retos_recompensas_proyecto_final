import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../recursos/MediaQuery.dart';
import '../../../datos/Colecciones.dart';
import '../../../datos/DatosPersonalUser.dart';
import '../../../datos/UsuarioActual.dart';
import '../cambiar_tutor_actual.dart';
import 'DejarTutoria.dart';

class UsuarioTutores {
  static var tutorActual;
  static Future setCurrentUser(initCurrenntTutor) async {
    Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .snapshots()
        .listen((event) {
      initCurrenntTutor(event['current_tutor']);
      tutorActual = event['current_tutor'];
    });
  }

  static getAllTutores(AppLocalizations? valores) {
    return StreamBuilder(
        stream: Coleciones.COLECCION_USUARIOS
            .doc(CurrentUser.getIdCurrentUser())
            .collection('rolTutorado')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('${valores?.ha_error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text('${valores?.no_tutor}'),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: getCardUsuarioTutor(
                        snapshot.data?.docs[index].id, context, valores),
                  ),
                );
              },
            );
          } else {
            return Text('${valores?.no_tutor}');
          }
        });
  }

  static getCardUsuarioTutor(String? idUsuario, BuildContext context, AppLocalizations? valores) {
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
        title: DatosPersonales.getDato(idUsuario, 'nombre',TextStyle(fontSize: 16)),
        subtitle: DatosPersonales.getDato(idUsuario, 'nombre_usuario', TextStyle(fontSize: 15)),
        trailing: SizedBox(
          height: Pantalla.getPorcentPanntalla(5, context, 'y'),
          width: Pantalla.getPorcentPanntalla(20, context, 'x'),
          child: Row(
            children: [MarcActualTutor(idUsuario), opciones(idUsuario, valores)],
          ),
        ),
      ),
    );
  }

  static String _selectedMenu = '';
  static Widget opciones(String idTutor, AppLocalizations? valores) {
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
                  onTap: () => DejarTutoria.eliminarTutor(context, idTutor, valores),
                  child: Text('${valores?.dejar_tutoria}'),
                ),
                PopupMenuItem<Menu>(
                  value: Menu.EliminarSala,
                  child: Text('${valores?.seleccionar_tutoria}'),
                  onTap: () => TutorActual.setNewActualTutor(idTutor),
                )
              ]);
    });
  }
}

enum Menu { AddMision, AddUsuario, EliminarSala }


class MarcActualTutor extends StatefulWidget {
  final idUsuario;
  const MarcActualTutor(this.idUsuario, {Key? key}) : super(key: key);

  @override
  State<MarcActualTutor> createState() => _MarcActualTutorState(idUsuario);
}

class _MarcActualTutorState extends State<MarcActualTutor> {
String idUsuario;
  _MarcActualTutorState(this.idUsuario);

void initCurrentTutor(currentTutor) {

  if(mounted)setState(() {});
}


@override
  void initState() {
    // TODO: implement initState
  UsuarioTutores.setCurrentUser(initCurrentTutor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UsuarioTutores.tutorActual == idUsuario
        ? Icon(
      Icons.person_pin_rounded,
    )
        : Icon(
      Icons.person_pin_rounded,
      color: Colors.transparent,
    );;
  }
}

