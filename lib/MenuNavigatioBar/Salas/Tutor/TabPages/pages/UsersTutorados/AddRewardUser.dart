import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';

import '../../../../../../datos/Colecciones.dart';
import '../../../../../../datos/UsuarioActual.dart';
import '../../../../../../widgets/Dialogs.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Establecer recompensa'),
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
              child: Text('Guardar'),
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
      decoration: const InputDecoration(
          hintText: 'ejemplo',
          border: OutlineInputBorder(),
          labelText: 'Título'),
    );
  }

  Widget _getTextFielContenido() {
    return TextField(
      maxLines: 5,
      maxLength: 200,
      autocorrect: true,
      controller: contenidoController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
          labelText: 'Contenido'),
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
          child: const Text('Ok'),
        ),
      ];
    }

    var tituloMensaje = 'Rellenar campo';
    var message = 'Es necesario asignar un titulo y un contenido para asignar una recompensa';

    Dialogos.mostrarDialog(actions, tituloMensaje, message, context);
  }
}
