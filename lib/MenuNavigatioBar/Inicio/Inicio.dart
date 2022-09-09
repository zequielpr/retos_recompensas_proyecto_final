import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';

import '../../datos/CollecUsers.dart';
import 'Tutorado/InicioVistaTutorado.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override

  var cofre_6;
  void initState(){
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
        title: Align(
          alignment: Alignment.center,
          child: Text('Home'),
        ),
        leading: IconButton(
          tooltip: 'Ajustes',
          onPressed: () {},
          icon: Icon(Icons.settings),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              tooltip: 'Historial',
              onPressed: () => context.router.pushNamed('Historial'),
              icon: Icon(Icons.history),
            ),
          )
        ],
      ),
      body: Column(children: <Widget>[
        Roll_Data.ROLL_USER_IS_TUTORADO
            ? InicioVistaTutorado.showCajaRecompensa(
                CollecUser.COLECCION_USUARIOS,
                'CGWDtkvBpPSFfsziW0T3x1zfEAt1',
                changeImage,
                cofre)
            : Text('inicio para el tutor'),
      ]),
    );
    ;
  }
}
