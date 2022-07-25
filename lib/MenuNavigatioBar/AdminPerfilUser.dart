import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AdminPerfilUser extends StatefulWidget {
  const AdminPerfilUser({Key? key}) : super(key: key);

  @override
  State<AdminPerfilUser> createState() => _AdminPerfilUserState();
}

class _AdminPerfilUserState extends State<AdminPerfilUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('adminPerfil'),
        ),
        body: Column(
        children: <Widget>[
          ElevatedButton(
              onPressed: () async {
                //print(FirebaseAuth.instance.currentUser?.providerData);


                await FirebaseAuth.instance.signOut().then((value) async => {

                  await _p(),
                  context.router.replaceNamed('/EsplashScreen')


                });


              },
              child: Text("Cerrar sesión"))
      ]      ),
    );
    ;
  }

  static Future<void> _p() async {
    try{
      await GoogleSignIn().disconnect();
    }catch(e){}
  }
}
