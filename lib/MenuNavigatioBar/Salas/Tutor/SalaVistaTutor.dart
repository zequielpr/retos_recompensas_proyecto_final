import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/recursos/Colores.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/AdminSala.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/Misiones.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/Ruleta.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/ListUsuariosTutorados.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';

import '../../../recursos/MediaQuery.dart';
import '../../../datos/TransferirDatos.dart';
import '../../../widgets/Dialogs.dart';
import '../../Perfil/AdminRoles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  AppLocalizations? valores;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }


  String _selectedMenu = '';

  @override
  Widget build(BuildContext contextSala) {
    valores = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(args.nombreSala),
        actions: [
          IconButton(
            onPressed: () {
              enviarSolicitudeUsuario.InterfaceEnviarSolicitud(
                  contextSala,  args.sala.getIdSala, args.nombreSala, valores);
            },
            icon: Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () => _crearMision(contextSala),
            icon: Icon(Icons.add),
          ),
          //Solo re refresca el widget del popup menu
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return PopupMenuButton<Menu>(
                // Callback that sets the selected popup menu item.
                onSelected: (Menu item) {
                  setState(() {
                    _selectedMenu = item.name;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                      PopupMenuItem<Menu>(
                        value: Menu.AddMision,
                        onTap: () => _crearMision(context),
                        child: Text(valores?.crear_mision as String),
                      ),
                      PopupMenuItem<Menu>(
                        value: Menu.EliminarSala,
                        child: Text(valores?.eliminar_sala as String),
                        onTap: () async {
                          await AdminSala.eliminarSala(
                              args.sala.getIdSala, contextSala, context, valores);
                        },
                      )
                    ]);
          }),
        ],
        bottom: TabBar(
          indicatorColor: Colores.colorPrincipal,
          controller: _tabController,
          tabs:  [
            Tab(
              child: Text(valores?.misiones as String),
            ),
            Tab(
              child: Text(valores?.usuarios as String),
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
                  contextSala: contextSala,
                  collectionReferenceMisiones: args.sala.getColecMisiones),
            ],
          ),
        ),
      ),
    );
  }

  _crearMision(BuildContext context) {
    AdminSala.comprobarNumMisiones(args.sala.getIdSala).then((value) {
      if (value <= 7) {
        context.router.push( AddMisionRouter(
            collectionReferenceMisiones: args.sala.getColecMisiones,
            contextSala: context));
      } else {
        var titulo = valores?.num_maximo_misiones_titulo as String;
        var mensaje = valores?.num_maximo_misiones;
        action(BuildContext context) {
          return <Widget>[
            TextButton(
              onPressed: () => context.router.pop(),
              child: Text('Ok'),
            )
          ];
        }

        Dialogos.mostrarDialog(action, titulo, mensaje, context);
      }
    });
  }
}
