//Menu de opcione para administrar el perfil
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';

import '../../../Rutas.gr.dart';

class MenuOption{
  static getMenuOption(BuildContext context, AppLocalizations? valores){
    var arrowSize = 16.0;
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(top: Pantalla.getPorcentPanntalla(2, context, 'x')),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: Colors.transparent,
              elevation: 0,
              margin: const EdgeInsets.all(0),
              child: ListTile(
                onTap: () => context.router.push(const AdminCuentaRoute()),
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.settings),
                title: Text(valores?.cuenta as String),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: arrowSize,
                ),
              ),
            ),
            Card(
              color: Colors.transparent,
              elevation: 0,
              margin: const EdgeInsets.all(0),
              child: ListTile(
                onTap: () => context.router.push(const EditarPerfilRouter()),
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.person),
                title: Text(valores?.editar_perfil as String),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: arrowSize,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}