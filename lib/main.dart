import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:retos_proyecto/splashScreen.dart';
import 'package:retos_proyecto/vista_tutor/ListaSalas.dart';
import 'package:retos_proyecto/vista_tutor/TabPages/TaPagesSala.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/vista_tutor/TabPages/pages/Misiones.dart';
import 'package:retos_proyecto/vista_tutorado/AdminCuenta.dart';
import 'package:retos_proyecto/vista_tutorado/Salas/ListaMisionesVtutorado.dart';
import 'package:retos_proyecto/vista_tutorado/Salas/ListaSalas.dart';

import 'Servicios/Notificaciones/notificaciones_bandeja.dart';
import 'Servicios/Autenticacion/login.dart';



class Inicio extends StatelessWidget {
  final  bool isTutorado;
  const Inicio(bool this.isTutorado, {Key? key}) : super(key: key);
  static const String _title = 'Flutter';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        TabPagesSala.routeName: (context) => const TabPagesSala(),
      },
      title: _title,
      home: MyStatefulWidget(isTutorado),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final bool isTutorado;
  const MyStatefulWidget(this.isTutorado, {Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(isTutorado);
}

//Clase donde se probara to el proceso de crear una misión
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final bool isTutorado;
  _MyStatefulWidgetState(this.isTutorado);

  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('se ha recibido una nueva notificacion');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('Se debería mostrar la notificacion');
        print(notification.title);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        print('final');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });

  }

  int _nab_var_index_actual = 0;
  int _selectedIndex = 0;
  int _Puntuacion = 1;

  final CollectionReference CollecionUsuarios = FirebaseFirestore.instance
      .collection('usuarios'); //Coleccion en la que se guardarán los usuarios

  //Constroladores de texto para extraer el contenido de los textFields
  final TextEditingController _tituloController = TextEditingController();

  String tituloModalBottomSheet = "";
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {

    String action = 'Guardar';
    tituloModalBottomSheet = "Añadir Sala";
    if (documentSnapshot != null) {
      tituloModalBottomSheet = "Actualizar libro";
      action = 'Modificar';
      _tituloController.text = documentSnapshot['NombreSala'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                    leading: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back) // the arrow back icon
                          ),
                    ),
                    title: Center(
                      child: Text(
                        tituloModalBottomSheet,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ), // Your desired title
                    )),
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'Guardar' ? 'Guardar' : 'Modificar'),
                  onPressed: () async {
                    final String? name = _tituloController.text;

                    if (name != null) {
                      if (action == 'Guardar') {
                        // Persist a new product to Firestore
                        await CollecionUsuarios.doc(
                                FirebaseAuth.instance.currentUser?.uid)
                            .collection('rolTutor')
                            .add({
                          "NombreSala": name,
                          'numMisiones': 0,
                          'numTutorados': 0
                        });
                      }

                      if (action == 'Modificar') {
                        // Update the product
                        await CollecionUsuarios.doc(documentSnapshot!.id)
                            .update({
                          "NombreSala": name,
                        });
                      }

                      // Clear the text fields
                      _tituloController.text = '';
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Rellene todos los campos. El precio debe ser un número entero')));
                    }

                    // Hide the bottom sheet
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  final List<Widget> _widgetOptions = <Widget>[];




  void _onItemTapped(int index) {
    setState(() {
      _nab_var_index_actual = _selectedIndex;
      _selectedIndex = index;
    });
  }


  //Esta coleccion contien las vista que se mostrará dependiendo del menu seleccionado
  iniciarColeccion(BuildContext context, bool isTutorado){
    _widgetOptions.clear();
    const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    if(isTutorado){
      _widgetOptions.addAll(<Widget>[
        bandejaNotificaciones.getBandejaNotificaciones(CollecionUsuarios, context),
        //Misiones.vistaCrearMisiones,
        //MenuOpcionesSala.getVistaSala,

        //tarjeta de las misiones---------------------------------------------------
        ListaSala_v_Tutorado.listar(context, CollecionUsuarios),

        AdminCuenta.getPerfilTutorado(context),

        Text("hola")
      ]);
    }else{
      _widgetOptions.addAll(<Widget>[
        bandejaNotificaciones.getBandejaNotificaciones(CollecionUsuarios, context),
        //Misiones.vistaCrearMisiones,
        //MenuOpcionesSala.getVistaSala,

        //Tarjeta de las salas---------------------------------------------------
        ListaSalas.getInstance(context, CollecionUsuarios),

        //Solo de prueba
        AdminCuenta.getPerfilTutorado(context),

        //Notificacion_Bandeja.getBodyAppVarBandejaNotifi(CollecionUsuarios)
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    iniciarColeccion(context, isTutorado);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: iniciarAppVar(),
        body: Container(
          alignment: Alignment.topCenter,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment_rounded),
              label: 'Salas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex > 2
              ? _nab_var_index_actual
              : _selectedIndex, //Evita que se salga del rango del tabvar
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createOrUpdate(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }




  Color colorBotonMisiones = Colors.white;
  Color colorBotonSolicitudes = Colors.red;
  List<bool> isSelected = [true, false];
  static const Color colorTextoToggle = Colors.black;
  //Metodos
  PreferredSizeWidget iniciarAppVar() {
    if (_selectedIndex != 3) {
      return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  _onItemTapped(3);
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        // title: const Text('BottomNavigationBar Sample'),
      );
    }
    return AppBar(
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  _onItemTapped(_nab_var_index_actual);
                },
                icon: Icon(Icons.arrow_back)),
            const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "Notificaciones",
                  style: TextStyle(fontSize: 25),
                )),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30, right: 10, bottom: 10),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colorBotonMisiones),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                    onPressed: () {
                      setState(() {
                        colorBotonMisiones = Colors.red;
                        colorBotonSolicitudes = Colors.white;
                      });
                    },
                    child: const Text(
                      "Misiones",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colorBotonSolicitudes),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                    onPressed: () {
                      setState(() {
                        colorBotonSolicitudes = Colors.red;
                        colorBotonMisiones = Colors.white;
                      });
                    },
                    child: const Text(
                      "Solicitudes",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    )),
              )
            ],
          ),
        ));
  }

  //Metodo que evitará que la aplicacion se salga sin preguntar
  Future<bool> _onWillPop() async {
    if (_selectedIndex > 0) {
      print("Index" + _selectedIndex.toString());
      _onItemTapped(0);
      return false;
    }
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
