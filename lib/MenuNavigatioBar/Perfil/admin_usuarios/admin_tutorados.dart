import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../MediaQuery.dart';
import 'eliminar_tutorado.dart';

class Admin_tutorados {
  static getAllUser( AppLocalizations? valores) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Coleciones.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutor')
          .doc(CurrentUser.getIdCurrentUser())
          .collection('allUsersTutorados')
          .doc('usuarios_tutorados').snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("${valores?.ha_error}");
        }

        if (!snapshot.hasData) {
          Text('${valores?.no_usuarios_tutoria}');
        }

        if (snapshot.hasData && snapshot.data!.data() != null) {
          print('hola');
          try{
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

            List<dynamic> listaUsuariosTutorados = data['idUserTotorado'];
            if(listaUsuariosTutorados.isEmpty){
              return Center(child: Text('${valores?.no_usuarios_tutoria}'),);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: listaUsuariosTutorados.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: getCardUsuarioTutorado(
                        listaUsuariosTutorados[index], context, valores),
                  ),
                );
              },
            );
          }catch(e, s){
            return Center(child: Text('${valores?.ha_error}'),);
          }
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }

        return Center(child: Text('${valores?.no_usuarios_tutoria}'),);
      },
    );
  }

  static getCardUsuarioTutorado(String idUsuario, BuildContext context, AppLocalizations? valores) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        dense: true,
        leading: DatosPersonales.getAvatar(idUsuario, 20),
        title: DatosPersonales.getDato(idUsuario, 'nombre', TextStyle(fontSize: 16)),
        subtitle: DatosPersonales.getDato(idUsuario, 'nombre_usuario', TextStyle(fontSize: 15)),
        trailing: SizedBox(
          height: Pantalla.getPorcentPanntalla(5, context, 'y'),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                ),
            child: Text('${valores?.eliminar}'),
            onPressed: () => EliminarTutorado.eliminarUserTutorado(context, idUsuario, valores),
          ),
        ),
      ),
    );
  }
}
