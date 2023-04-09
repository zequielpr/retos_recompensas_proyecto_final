import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';

import '../../../../../../datos/Colecciones.dart';
import '../../../../../../datos/UsuarioActual.dart';
import '../../../../../../widgets/Dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddReward extends StatefulWidget {
  final userId;
  const AddReward({Key? key, this.userId}) : super(key: key);

  @override
  State<AddReward> createState() => _AddRewardState(userId);
}

class _AddRewardState extends State<AddReward> {
  var tituloController = TextEditingController();
  var contenidoController = TextEditingController();
  var userId;
  _AddRewardState(this.userId);
  AppLocalizations? valores;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${valores?.add_recompensa}'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: Pantalla.getPorcentPanntalla(7, context, 'y'),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Pantalla.getPorcentPanntalla(5, context, 'x'),
                right: Pantalla.getPorcentPanntalla(5, context, 'x'),
              ),
              child: _getTextFielTitulo(),
            ),
            SizedBox(
              height: Pantalla.getPorcentPanntalla(3, context, 'y'),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Pantalla.getPorcentPanntalla(5, context, 'x'),
                  right: Pantalla.getPorcentPanntalla(5, context, 'x')),
              child: _getTextFielContenido(),
            ),
            SizedBox(
              height: Pantalla.getPorcentPanntalla(3, context, 'y'),
            ),
            ElevatedButton(
              onPressed: () async =>
                  addReward(tituloController.text, contenidoController.text),
              child: Text('${valores?.guardar}'),
            )
          ],
        ),
      ),
    );
  }

  Widget _getTextFielTitulo() {
    return TextField(
      maxLength: 20,
      autofocus: true,
      autocorrect: true,
      controller: tituloController,
      decoration: InputDecoration(
          hintText: '${valores?.ejemplo}',
          border: OutlineInputBorder(),
          labelText: '${valores?.titulo}'),
    );
  }

  Widget _getTextFielContenido() {
    return TextField(
      maxLines: 5,
      maxLength: 200,
      autocorrect: true,
      controller: contenidoController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
          border: const OutlineInputBorder(),
          labelText: '${valores?.contenido}'),
    );
  }

  //Añdir recompensa al usuario tutorado
  Future<void> addReward(String titulo, String contenido) async {
    var titulo = tituloController.text;
    var contenido = contenidoController.text;

    if (titulo.isNotEmpty && contenido.isNotEmpty) {
      await Coleciones.COLECCION_USUARIOS
          .doc(userId)
          .collection("rolTutorado")
          .doc(CurrentUser.getIdCurrentUser())
          .update({
        "recompensa_x_200": {titulo: contenido}
      }).whenComplete(() => {Navigator.pop(context)});
      return;
    }



    actions(BuildContext context){
      return <Widget>[
        TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: Text('${valores?.ok}'),
        ),
      ];
    }

    var tituloMensaje = '${valores?.rellenar_campos}';
    var message = '${valores?.titulo_contenido_recompensa}';

    Dialogos.mostrarDialog(actions, tituloMensaje, message, context);
  }
}
