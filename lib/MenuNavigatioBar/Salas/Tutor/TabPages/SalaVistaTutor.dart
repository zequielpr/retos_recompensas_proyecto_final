import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/Misiones.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/Ruleta.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/ListUsuariosTutorados.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

import '../../../../datos/TransferirDatos.dart';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class SalaContVistaTutor extends StatefulWidget {
  final TransferirDatos args;
  const SalaContVistaTutor({Key? key, required this.args}) : super(key: key);

  @override
  State<SalaContVistaTutor> createState() => _SalaContVistaTutorState(args);
}

enum Menu { AddMision, AddUsuario, EliminarSala}
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args.nombreSala),
        actions: [
          IconButton(
            onPressed: () {
              enviarSolicitudeUsuario.InterfaceEnviarSolicitud(
                  context, args.collecionUsuarios, args.sala.getIdSala);
            },
            icon: Icon(Icons.person_add),
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
                  onTap: (){context.router.push(AddMisionRouter(collectionReferenceMisiones: CollecUser.COLECCION_USUARIOS, contextSala: context));},
                  child: Text('Añadir misión'),
                ),
                const PopupMenuItem<Menu>(
                  value: Menu.AddUsuario,
                  child: Text('Añadir usuario'),
                ),
                const PopupMenuItem<Menu>(
                  value: Menu.EliminarSala,
                  child: Text('Eliminar sala'),
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
                  contextSala: context),
              ListUsuarios(
                  collectionReferenceUsuariosTutorados:
                      args.sala.getColecUsuariosTutorados,
                  collectionReferenceUsuariosDocPersonal:
                      args.collecionUsuarios,
                  contextSala: context,
                  collectionReferenceMisiones: args.sala.getColecMisiones),
            ],
          ),
        ),
      ),
    );
  }
}
