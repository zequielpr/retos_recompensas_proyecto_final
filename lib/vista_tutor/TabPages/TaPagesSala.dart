import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../datos/TransferirDatos.dart';
import 'pages/Misiones.dart';
import 'pages/Ruleta.dart';
import 'pages/UsersTutorados/ListUsuariosTutorados.dart';

//Store this globally
final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class TabPagesSala extends StatefulWidget {
  const TabPagesSala({Key? key}) : super(key: key);

  static const ROUTE_NAME = '/extractArguments';

  print(text) {
    // TODO: implement print
    throw UnimplementedError();
  }

  @override
  _TabPagesSalaState createState() => _TabPagesSalaState();
}

class _TabPagesSalaState extends State<TabPagesSala>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TransferirDatos;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.nombreSala),
        actions: [

          Padding(padding: EdgeInsets.only(right: 20), child: IconButton(
              onPressed: () {
                enviarSolicitudeUsuario.InterfaceEnviarSolicitud(
                    context, args.collecionUsuarios, args.sala.getIdSala);
              },
              icon: Icon(Icons.person_add)),)
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
            Tab(
              child: Text('Ruleta'),
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
                      args.collecionUsuarios, contextSala: context, collectionReferenceMisiones: args.sala.getColecMisiones),
              Ruleta(collectionReferenceRuleta: args.sala.getColecRuletas),
            ],
          ),
        ),
      ),
    );
  }
}
