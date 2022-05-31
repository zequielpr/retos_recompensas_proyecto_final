import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:retos_proyecto/splashScreen.dart';
import 'package:retos_proyecto/vista_tutor/ListaSalas.dart';
import 'package:retos_proyecto/vista_tutor/MenuOpciones/MenuOpcionesSala.dart';

import 'login.dart';


class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        MenuSala.routeName: (context) =>
        const MenuSala(),
      },
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}


//Clase donde se probara to el proceso de crear una misión
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('se ha recibido una nueva notificacion');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
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

  int _selectedIndex = 0;
  int _Puntuacion = 1;

  final CollectionReference CollecionUsuarios = FirebaseFirestore.instance.collection('usuarios'); //Coleccion en la que se guardarán los usuarios

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

                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back) // the arrow back icon
                      ),
                    ),
                    title: Center(
                      child: Text(tituloModalBottomSheet, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),), // Your desired title
                    )
                ),


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

                    if (name != null ) {
                      if (action == 'Guardar') {
                        // Persist a new product to Firestore
                        await CollecionUsuarios.doc(FirebaseAuth.instance.currentUser?.uid).collection('rolTutor').add({"NombreSala": name, 'numMisiones': 0, 'numTutorados': 0});
                      }


                      if (action == 'Modificar') {
                        // Update the product
                        await CollecionUsuarios
                            .doc(documentSnapshot!.id)
                            .update({"NombreSala": name, });
                      }

                      // Clear the text fields
                      _tituloController.text = '';



                    }else{


                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Rellene todos los campos. El precio debe ser un número entero')));
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




  List<Widget> _widgetOptions = <Widget>[];
  /*static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  final List<Widget> _widgetOptions = <Widget>[


    Text('Holaa'),
    //Misiones.vistaCrearMisiones,
    //MenuOpcionesSala.getVistaSala,

  Salas.getInstance,
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  //Esta coleccion contien las vista que se mostrará dependiendo del menu seleccionado
  void iniciarColeccion(BuildContext context) {
    const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    _widgetOptions.addAll(
        <Widget>[


          Text('Hola'),
          //Misiones.vistaCrearMisiones,
          //MenuOpcionesSala.getVistaSala,


          //tarjeta de las misiones---------------------------------------------------
          ListaSalas.getInstance(context, CollecionUsuarios),


          const Text(
            'Index 2: School',
            style: optionStyle,
          ),
        ]
    );

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    iniciarColeccion(context);
    return Scaffold(
      appBar: AppBar(
        // title: const Text('BottomNavigationBar Sample'),
      ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
