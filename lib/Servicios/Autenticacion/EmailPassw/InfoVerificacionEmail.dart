import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';

import '../../../Rutas.gr.dart';
import '../../../datos/TransferirDatos.dart';
import '../../../datos/UsuarioActual.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  AppLocalizations? valores;

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
    valores = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(valores?.titulo_verificar_email as String),
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
                  child: Text(valores?.verificacion_email_necesaria as String,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500), textAlign: TextAlign.center,
                  ),
                ),),
                Text(
                  '${valores?.parrafo_verificar_email} ${ arg.email} ${valores?.parrafo_verificar_email_2}.',
                  textAlign: TextAlign.center,
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
                      child: Text(valores?.inicia_sesion as String)),
                )

              ],
            ),
          ),
        ));
    ;
  }

  void _irInicioSesion(arg) {
    context.router.replace(IniSesionEmailPasswordRouter(args: arg));
    //_context.router.replace(MainRouter())
  }
}
