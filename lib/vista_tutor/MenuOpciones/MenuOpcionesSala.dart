import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../datos/TransferirDatos.dart';
import 'Misiones.dart';
import 'Ruleta.dart';
import 'UsuariosTutorados.dart';



//Store this globally
final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class MenuSala extends StatefulWidget {

  const MenuSala({Key? key}) : super(key: key);

  static const routeName = '/extractArguments';

  print(text) {
    // TODO: implement print
    throw UnimplementedError();
  }
  @override
  _MenuSalaState createState() => _MenuSalaState();

}



class _MenuSalaState extends State<MenuSala> with SingleTickerProviderStateMixin {
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
            children:  [
              Misiones(collectionMisiones: args.sala.getColecMisiones, contextSala: context),
              Usuarios(collectionReferenceUsuariosTutorados: args.sala.getColecUsuariosTutorados, collectionReferenceUsuariosDocPersonal: args.collecionUsuarios),
              Ruleta(collectionReferenceRuleta: args.sala.getColecRuletas),

            ],
          ),
        ),
      ),
    );
  }
}


