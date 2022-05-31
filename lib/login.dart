
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'AdministrarTokens.dart';
import 'Autenticacion.dart';
import 'main.dart';
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  final passw = TextEditingController();
  final correo = TextEditingController();
  String descripcion = '';
  @override
  Widget build(BuildContext context) {
    final correo = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            //Iniciar sesion con google
            ElevatedButton(
              child: Text('iniciar sesión con google'),
              onPressed: () async {
                User? user = await Autenticar.signInWithGoogle(context);
                print(user?.email);
                Token.guardarToken();




              },
            ),

          ],
        ),
      ),
    );
  }


}

