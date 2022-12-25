import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../MediaQuery.dart';
import 'eliminar_tutorado.dart';

class Admin_tutorados {
  static getAllUser(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: CollecUser.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutor')
          .doc(CurrentUser.getIdCurrentUser())
          .collection('allUsersTutorados')
          .doc('usuarios_tutorados').snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData) {
          Text('Aun no tienes usuarios en tu tutoría');
        }

        if (snapshot.hasData && snapshot.data!.data() != null) {
          print('hola');
          try{
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

            List<dynamic> listaUsuariosTutorados = data['idUserTotorado'];
            if(listaUsuariosTutorados.isEmpty){
              return const Center(child: Text('Aun no tienes usuarios en tu tutoría'),);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: listaUsuariosTutorados.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: getCardUsuarioTutorado(
                        listaUsuariosTutorados[index], context),
                  ),
                );
              },
            );
          }catch(e, s){
            print('Error $e');
            return const Center(child: Text('Ha ocurrido un error'),);
          }
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }

        return const Center(child: Text('Aun no tienes usuarios en tu tutoría'),);
      },
    );
  }

  static getCardUsuarioTutorado(String idUsuario, BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        dense: true,
        leading: DatosPersonales.getAvatar(idUsuario, 20),
        title: DatosPersonales.getDato(idUsuario, 'nombre'),
        subtitle: DatosPersonales.getDato(idUsuario, 'nombre_usuario'),
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
            child: Text('Eliminar'),
            onPressed: () => EliminarTutorado.eliminarUserTutorado(context, idUsuario),
          ),
        ),
      ),
    );
  }
}
