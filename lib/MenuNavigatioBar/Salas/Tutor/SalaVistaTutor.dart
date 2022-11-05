import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/AdminSala.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/Misiones.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/Ruleta.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/ListUsuariosTutorados.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

import '../../../MediaQuery.dart';
import '../../../datos/TransferirDatos.dart';
import '../../Perfil/AdminRoles.dart';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class SalaContVistaTutor extends StatefulWidget {
  final TransferirDatos args;
  const SalaContVistaTutor({Key? key, required this.args}) : super(key: key);

  @override
  State<SalaContVistaTutor> createState() => _SalaContVistaTutorState(args);
}

enum Menu { AddMision, AddUsuario, EliminarSala }

//_SalaContVistaTutorState
class _SalaContVistaTutorState extends State<SalaContVistaTutor>
    with SingleTickerProviderStateMixin {
  final TransferirDatos args;
  _SalaContVistaTutorState(this.args);
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  String _selectedMenu = '';

  @override
  Widget build(BuildContext contextSala) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args.nombreSala),
        actions: [
          IconButton(
            onPressed: () {
              enviarSolicitudeUsuario.InterfaceEnviarSolicitud(
                  contextSala, args.collecionUsuarios, args.sala.getIdSala);
            },
            icon: Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: ()=> _crearMision(contextSala),
            icon: Icon(Icons.add),
          ),
          PopupMenuButton<Menu>(
              // Callback that sets the selected popup menu item.
              onSelected: (Menu item) {
                setState(() {
                  _selectedMenu = item.name;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    PopupMenuItem<Menu>(
                      value: Menu.AddMision,
                      onTap: () {
                        context.router.push(AddMisionRouter(
                            collectionReferenceMisiones:
                                CollecUser.COLECCION_USUARIOS,
                            contextSala: context));
                      },
                      child: Text('Añadir misión'),
                    ),
                    PopupMenuItem<Menu>(
                      value: Menu.EliminarSala,
                      child: Text('Eliminar sala'),
                      onTap: () async {
                        await AdminSala.eliminarSala(
                            args.sala.getIdSala, contextSala, context);
                      },
                    )
                  ]),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text('Misiones'),
            ),
            Tab(
              child: Text('Usuarios'),
            ),
          ],
        ),
      ),
      body: Navigator(
        key: _navKey,
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => TabBarView(
            controller: _tabController,
            children: [
              Misiones(
                  collectionMisiones: args.sala.getColecMisiones,
                  contextSala: contextSala),
              ListUsuarios(
                  collectionReferenceUsuariosTutorados:
                      args.sala.getColecUsuariosTutorados,
                  collectionReferenceUsuariosDocPersonal:
                      args.collecionUsuarios,
                  contextSala: contextSala,
                  collectionReferenceMisiones: args.sala.getColecMisiones),
            ],
          ),
        ),
      ),
    );
  }

  _crearMision(BuildContext context){

    AdminSala.comprobarNumMisiones(args.sala.getIdSala).then((value){
      if(value <= 7){
        context.router.push(AddMisionRouter(
            collectionReferenceMisiones: args.sala.getColecMisiones,
            contextSala: context));
      }else{
        showMessaje();
      }
    });

  }

  showMessaje() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(3, context, 'x'),
            top: Pantalla.getPorcentPanntalla(3, context, 'x'),
            bottom: Pantalla.getPorcentPanntalla(1, context, 'x')),
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        buttonPadding: const EdgeInsets.all(0),
        actionsPadding:
        EdgeInsets.only(top: Pantalla.getPorcentPanntalla(0, context, 'x')),
        contentPadding: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(3, context, 'x'),
            right: Pantalla.getPorcentPanntalla(3, context, 'x')),
        title: const Text('Numero maximo de misiones', textAlign: TextAlign.center),
        content: const Text(
          'Elimina una misión para crear una nueva',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.router.pop(),
            child: Text('Ok'),
          )
        ],
      ),
    );
  }
}
