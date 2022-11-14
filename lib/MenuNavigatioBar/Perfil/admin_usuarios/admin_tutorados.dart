import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../MediaQuery.dart';

class Admin_tutorados {
  static getAllUser(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: CollecUser.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutor')
          .doc(CurrentUser.getIdCurrentUser())
          .collection('allUsersTutorados')
          .doc('usuarios_tutorados')
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          Text('Aun no tienes usuarios en tu tutoría');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          var listaUsuariosTutorados = data['idUserTotorado'];

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
          return Text(
              "Full Name: ${data['idUserTotorado']} ${data['last_name']}");
        }

        return Text("loading");
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
        onTap: () => print('object'),
        /*leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581413287870&di=35491998b94817cbcf04d9f9f3d2d4b3&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2464547320%2C3316604757%26fm%3D214%26gp%3D0.jpg"),
                ),*/
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
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 15))),
            child: Text('Eliminar'),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
