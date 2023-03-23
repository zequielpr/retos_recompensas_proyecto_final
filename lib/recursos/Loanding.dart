import 'package:flutter/material.dart';

import 'Colores.dart';
import 'MediaQuery.dart';

class Loanding{
  static Widget getLoanding(Widget body, BuildContext context){
    return Container(
      child: Stack(
        children: <Widget>[
          body,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: const BoxDecoration(),
            child: Container(
              decoration: BoxDecoration(
                  color: Colores.colorPrincipal,
                  borderRadius: BorderRadius.circular(10.0)),
              width: Pantalla.getPorcentPanntalla(16, context, 'x'),
              height: Pantalla.getPorcentPanntalla(16, context, 'x'),
              alignment: AlignmentDirectional.center,
              child: Transform.scale(
                scale: 0.7,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
}
}