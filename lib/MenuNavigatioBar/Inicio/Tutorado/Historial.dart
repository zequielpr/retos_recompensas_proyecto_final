import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:retos_proyecto/Colores.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';

import '../../../datos/TransferirDatos.dart';
import '../../../datos/UsuarioActual.dart';
import 'package:intl/intl.dart';

import '../../Perfil/admin_usuarios/Admin_tutores.dart';

class Historial extends StatefulWidget {
  const Historial({
    Key? key,
  }) : super(key: key);

  @override
  State<Historial> createState() => _HistorialState();
}

enum Campos { titulo, fehca_reclamo }

enum Orden { ascendente, descendente }

class _HistorialState extends State<Historial> {
  Campos? _campo = Campos.titulo;
  Orden? orden = Orden.ascendente;
  var campo = 'titulo';
  var order = false;
  var isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => dialogOrdenar(),
              icon: Padding(
                  padding: EdgeInsets.only(
                      right: Pantalla.getPorcentPanntalla(2, context, 'x')),
                  child: Icon(Icons.filter_list)),
            )
          ],
          title: Text('Recompensas recibidas'),
        ),
        body: _getTodasRecompensas(Coleciones.COLECCION_USUARIOS,
            UsuarioTutores.tutorActual, campo, order)
        //_getTidasRecompensas(
        //                 CollecUser.COLECCION_USUARIOS, 'hr44Bc4CRqWJjFfDYMCBmu707Qq1')
        );
  }

  //Dialog para para las opciones de orden
  void dialogOrdenar() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 200,
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Ordenar por:',
                            style: TextStyle(fontSize: 22),
                          ),
                          Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                title: const Text(
                                  'Título',
                                  style: TextStyle(fontSize: 22),
                                ),
                                leading: Radio<Campos>(
                                  value: Campos.titulo,
                                  groupValue: _campo,
                                  onChanged: (Campos? value) {
                                    setState(() {
                                      _campo = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: const Text(
                                  'Fecha de reclamo',
                                  style: TextStyle(fontSize: 22),
                                ),
                                leading: Radio<Campos>(
                                  value: Campos.fehca_reclamo,
                                  groupValue: _campo,
                                  onChanged: (Campos? value) {
                                    setState(() {
                                      _campo = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text('Orden:', style: TextStyle(fontSize: 22)),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                title: const Text(
                                  'Ascendente',
                                  style: TextStyle(fontSize: 22),
                                ),
                                leading: Radio<Orden>(
                                  value: Orden.ascendente,
                                  groupValue: orden,
                                  onChanged: (Orden? value) {
                                    setState(() {
                                      orden = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                title: const Text(
                                  'Descendente',
                                  style: TextStyle(fontSize: 22),
                                ),
                                leading: Radio<Orden>(
                                  value: Orden.descendente,
                                  groupValue: orden,
                                  onChanged: (Orden? value) {
                                    setState(() {
                                      orden = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ), //

                          SizedBox(height: 24.0),
                          InkWell(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16.0),
                                      bottomRight: Radius.circular(16.0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context.router.pop();
                                      },
                                      child: const Text(
                                        "Cancelar",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        campo = (_campo.toString() ==
                                                'Campos.fehca_reclamo')
                                            ? 'fehca_reclamo'
                                            : 'titulo';
                                        order = (orden.toString() ==
                                                'Orden.descendente')
                                            ? true
                                            : false;
                                        print(campo);
                                        print(order);
                                        ordenar(campo, order);
                                        context.router.pop();
                                      },
                                      child: const Text(
                                        "OK",
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  //Ordenar las recomensas en orden alfabetico(A-Z y Z-A), fecha(Reciente-Antigua y Antigua-Reciente)
  /** True = descendente. False ascendente**/
  void ordenar(String campo, bool orden) {
    setState(() {
      this.campo = campo;
      this.order = orden;
    });
  }

  Widget _getTodasRecompensas(CollectionReference collectionReferenceUser,
      String idTutorActual, campo, orden) {

    if(idTutorActual.isEmpty){
      return const Center(child: Text('Aún no tienes una tutoría'),);
    }

    return FutureBuilder<QuerySnapshot>(
      future: collectionReferenceUser
          .doc(CurrentUser.getIdCurrentUser())
          .collection('rolTutorado')
          .doc(idTutorActual)
          .collection('billeteraRecompensas')
          .orderBy(campo, descending: order)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }

        if(snapshot.data?.docs.isEmpty == true){
          return const Center(child: Text('Historial vacío'),);
        }

        if (snapshot.hasData) {
          print('object');
          List<Widget> listaRecompensa = [Text('hola')];

          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            listaRecompensa.add(getCardRecompensa(
                data['titulo'], data['contenido'], data['fehca_reclamo']));
          });

          var top = Pantalla.getPorcentPanntalla(5, context, 'y');
          var left = Pantalla.getPorcentPanntalla(3, context, 'x');
          var right = Pantalla.getPorcentPanntalla(3, context, 'x');

          var ratio = Pantalla.getPorcentPanntalla(0.24, context, 'y');
          return GridView.count(
            padding: EdgeInsets.only(top: top, left: left, right: right),
            childAspectRatio: ratio,
            crossAxisSpacing: Pantalla.getPorcentPanntalla(3, context, 'x'),
            mainAxisSpacing: Pantalla.getPorcentPanntalla(3, context, 'x'),
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return getCardRecompensa(
                      data['titulo'], data['contenido'], data['fehca_reclamo']);
                })
                .toList()
                .cast(),
          );
        }

        return const Text('vacío');
      },


    );
  }

  Widget getCardRecompensa(
      String titulo, String contenido, Timestamp fechaReclamo) {
    return Card(
      elevation: 0,
      color: Colores.colorPrincipal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => mostrarContenido(titulo, contenido),
            visualDensity: VisualDensity.compact,
            title: Text(
              titulo,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            subtitle: Text(
              contenido,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: Pantalla.getPorcentPanntalla(3, context, 'x')),
                child: Text(
                  'Reclamado en ${DateFormat('dd-MM-yyyy').format(fechaReclamo.toDate())}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  //Mostrar contenido de la recompensa
  void mostrarContenido(String titulo, String contenido) {
    showDialog<void>(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(
              top: Pantalla.getPorcentPanntalla(2, context, 'y'),
              bottom: Pantalla.getPorcentPanntalla(2, context, 'y')),
          content: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(0),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: <BoxShadow>[]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        titulo,
                        style: TextStyle(fontSize: 25),
                      ),
                      const Divider(
                          indent: 10, endIndent: 10, color: Colors.black),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          contenido,
                          style: TextStyle(fontSize: 23),
                        ),
                      ) //
                          ),
                      SizedBox(
                          height:
                              Pantalla.getPorcentPanntalla(1, context, 'y')),
                      InkWell(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0)),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text(
                              "OK",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
