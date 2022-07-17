import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IniSesionEmailPassword extends StatefulWidget {
  static const ROUTE_NAME = 'iniciarSesionEmailPassw';
  const IniSesionEmailPassword({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _IniSesionEmailPassword();
}

class _IniSesionEmailPassword extends State<IniSesionEmailPassword> {
  var email = TextEditingController();
  var passwd = TextEditingController();
  var iconPassw = Icon(Icons.visibility);
  var passwOculta = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 100, left: 40, right: 40),
          child: Column(
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: TextField(
                  controller: passwd,
                  obscureText: passwOculta,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => passwOculta == true
                            ? _mostrarPassw()
                            : _ocultarPassw(),
                        icon: iconPassw,
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Contraseña'),
                ),
              ),
              SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        await inciarSesionEmailPasswd(email.text, passwd.text);
                      },
                      child: Text(
                        'Iniciar sesion',
                        style: GoogleFonts.roboto(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarPassw() {
    setState(() {
      passwOculta = false;
      iconPassw = Icon(Icons.visibility_off);
    });
  }

  void _ocultarPassw() {
    setState(() {
      passwOculta = true;
      iconPassw = Icon(Icons.visibility);
    });
  }

  //Obtener credenciales con los datos especificados

  Future<void> inciarSesionEmailPasswd(String email, String password) async {
    try {
      print(email);
      print(password);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user');
      }
    }
  }
}

//Registrarse con email y contrase
class RecogerEmail extends StatefulWidget {
  static const ROUTE_NAME = 'RecogerEmail';
  const RecogerEmail({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecogerEmail();
}

class _RecogerEmail extends State<RecogerEmail> {
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final val = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
    emailController.selection = val;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 150, left: 30, right: 30),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, RecogerPassw.ROUTE_NAME);
                        },
                        child: Text(
                          'Continuar',
                          style: GoogleFonts.roboto(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//Recoger contraseña
class RecogerPassw extends StatefulWidget {
  static const ROUTE_NAME = 'RecogerPassw';
  const RecogerPassw({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecogerPassw();
}

class _RecogerPassw extends State<RecogerPassw> {
  var passwController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 150, left: 30, right: 30),
          child: Column(
            children: [
              TextField(
                controller: passwController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Contraseña'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Continuar',
                          style: GoogleFonts.roboto(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
