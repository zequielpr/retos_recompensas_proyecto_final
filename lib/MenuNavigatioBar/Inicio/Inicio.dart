import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';

import '../../datos/CollecUsers.dart';
import '../Perfil/AdminTutores.dart';
import '../Perfil/admin_usuarios/Admin_tutores.dart';
import 'Tutor/VistaInicioTutor.dart';
import 'Tutorado/InicioVistaTutorado.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentTutor;

  void initCurrentTutor(currentTutor){
    setState(() {
      this.currentTutor = currentTutor;
    });
  }
  @override

  var cofre_6;
  @override
  void initState(){
    var initCurrentTutor = this.initCurrentTutor;
    UsuarioTutores.setCurrentUser(initCurrentTutor);
    super.initState();
    cofre_6 = Image.asset("lib/imgs/cofre/cofre_6.png");
  }

  //Metodo callback abriendo cofre
  /*
  String cofre_1 = "lib/imgs/cofre/cofre_1.png";
  String cofre_2 = "lib/imgs/cofre/cofre_2.png";
  String cofre_3 = "lib/imgs/cofre/cofre_3.png";
  String cofre_4 = "lib/imgs/cofre/cofre_4.png";
  String cofre_5 = "lib/imgs/cofre/cofre_5.png";
  String cofre_6 = "lib/imgs/cofre/cofre_6.png";
   */

  var cofres = [
    "lib/imgs/cofre/cofre_1.png",
    "lib/imgs/cofre/cofre_2.png",
    "lib/imgs/cofre/cofre_3.png",
    "lib/imgs/cofre/cofre_4.png",
    "lib/imgs/cofre/cofre_5.png",
    "lib/imgs/cofre/cofre_6.png"
  ];

  var cofre = Image.asset("lib/imgs/cofre/cofre_1.png");

  void changeImage() {
    var count = 0;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      count++;
      setState(() {
        print("holaaaa");
        cofre = cofre_6;
      });

      if(count == 5){
        timer.cancel();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
        leading: IconButton(
          tooltip: 'Ajustes',
          onPressed: () {},
          icon: Icon(Icons.settings),
        ),
        actions: [
          Roll_Data.ROLL_USER_IS_TUTORADO?
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              tooltip: 'Historial',
              onPressed: () => context.router.pushNamed('Historial'),
              icon: Icon(Icons.history),
            ),
          ):Text('')
        ],
      ),
      body: Roll_Data.ROLL_USER_IS_TUTORADO ? getInicioCurrentTutor():InicioTutor(),
    );
    ;
  }

  Widget getInicioCurrentTutor(){
    if(currentTutor!= null && currentTutor.length != 0){
      return  InicioVistaTutorado.showCajaRecompensa(
          CollecUser.COLECCION_USUARIOS,
          currentTutor,
          changeImage,
          cofre);
    }else{
      return Center(child: Text('Aun no tienes una tutoría'),);
    }

  }
}
