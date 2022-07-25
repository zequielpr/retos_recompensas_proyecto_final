

import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/Misiones.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/Ruleta.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/ListUsuariosTutorados.dart';

import '../../../../datos/TransferirDatos.dart';
final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
class SalaContVistaTutor extends StatefulWidget {
  final TransferirDatos args;
  const SalaContVistaTutor({Key? key, required this.args}) : super(key: key);

  @override
  State<SalaContVistaTutor> createState() => _SalaContVistaTutorState(args);
}

//_SalaContVistaTutorState
class _SalaContVistaTutorState extends State<SalaContVistaTutor>
    with SingleTickerProviderStateMixin {
  final TransferirDatos args;
  _SalaContVistaTutorState(this.args);
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
