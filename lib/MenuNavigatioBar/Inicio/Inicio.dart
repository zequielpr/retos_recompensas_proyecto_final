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
                CollecUser.COLECCION_USUARIOS, 'VLq2hHV2ZbdrabyEAI7RTs9ZfGB3')
            : Text('inicio para el tutor'),
      ]),
    );
    ;
  }
}
