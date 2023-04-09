import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';

import '../../datos/Colecciones.dart';
import '../Perfil/admin_usuarios/Admin_tutores.dart';
import 'Tutor/VistaInicioTutor.dart';
import 'Tutorado/InicioVistaTutorado.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentTutor = '';
  AppLocalizations? valores;

  void initCurrentTutor(currentTutor){
    if(mounted) {
      setState(() {
      this.currentTutor = currentTutor;
    });
    }
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


  var cofre = Image.asset("lib/imgs/cofre/cofre_1.png");

  void changeImage() {
    var count = 0;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      count++;
      setState(() {;
        cofre = cofre_6;
      });

      if(count == 5){
        timer.cancel();
      }
    });
  }

  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)?.inicio as String),
        actions: [
          Roll_Data.ROLL_USER_IS_TUTORADO?
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              tooltip: valores?.historial,
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
    if(currentTutor.isNotEmpty){
      return  InicioVistaTutorado.showCajaRecompensa(
          Coleciones.COLECCION_USUARIOS,
          currentTutor,
          changeImage,
          cofre, valores);
    }else{
      return Center(child: Text(valores?.no_tutoria as String),);
    }

  }
}
