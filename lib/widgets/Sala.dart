import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../datos/SalaDatos.dart';
import '../datos/TransferirDatos.dart';
import '../vista_tutor/TabPages/TaPagesSala.dart';

class Sala {
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
            TabPagesSala.routeName,
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

  //Aspecto que tendrán las salas para los usuario tutorados
  static Widget vistaTutorado(
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
            TabPagesSala.routeName,
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
                        width: 130,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Icon(Icons.done, size: 18),
                            ),
                            Text(documentSnapshot['numTutorados'].toString(),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.right),
                            Padding(
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
                            Padding(
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
}
