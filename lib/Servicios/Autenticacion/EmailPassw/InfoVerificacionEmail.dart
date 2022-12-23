import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';

import '../../../Rutas.gr.dart';
import '../../../datos/TransferirDatos.dart';
import '../../../datos/UsuarioActual.dart';

class InfoVerificacionEmail extends StatefulWidget {
  final TransDatosInicioSesion arg;
  const InfoVerificacionEmail({Key? key, required this.arg}) : super(key: key);

  @override
  State<InfoVerificacionEmail> createState() =>
      _InfoVerificacionEmailState(arg);
}

class _InfoVerificacionEmailState extends State<InfoVerificacionEmail> {
  final TransDatosInicioSesion arg;
  _InfoVerificacionEmailState(this.arg);

  @override
  void initState() {
    // TODO: implement initState
    verificarEmail();
    super.initState();
  }

  void verificarEmail() async {
    await CurrentUser.currentUser?.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Verificar email'),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(
                right: Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x'),
                left: Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x')),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: Pantalla.getPorcentPanntalla(2, context, 'y')),
                  child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Verificación de email necesaria',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),),
                Text(
                  'Para verificar el email, abra el link enviado a ${arg.email} y luego inicie sesión.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: Pantalla.getPorcentPanntalla(4, context, 'y'),
                ),
                SizedBox(
                  width: Pantalla.getPorcentPanntalla(50, context, 'x'),
                  height: Pantalla.getPorcentPanntalla(6, context, 'y'),
                  child: ElevatedButton(
                      onPressed: () => _irInicioSesion(arg),
                      child: Text('Iniciar sesión')),
                )

              ],
            ),
          ),
        ));
    ;
  }

  Future<void> _irInicioSesion(arg) async {
    context.router.replace(IniSesionEmailPasswordRouter(args: arg));
    //_context.router.replace(MainRouter())
  }
}
