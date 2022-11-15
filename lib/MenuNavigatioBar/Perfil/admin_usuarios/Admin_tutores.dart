import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../MediaQuery.dart';
import '../../../datos/CollecUsers.dart';
import '../../../datos/DatosPersonalUser.dart';
import '../../../datos/UsuarioActual.dart';

class UsuarioTutores {
  static getAllTutores() {
    return FutureBuilder<QuerySnapshot>(
      future: CollecUser.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutorado')
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData) {
          Text('Aun no tienes usuarios en tu tutoría');
        }

        if (snapshot.connectionState == ConnectionState.done) {

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
        }

        return Text("loading");
      },
    );
  }

  static getCardUsuarioTutorado(String? idUsuario, BuildContext context) {
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
        leading: DatosPersonales.getAvatar(idUsuario!, 20),
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
