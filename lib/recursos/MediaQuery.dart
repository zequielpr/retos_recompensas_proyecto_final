import 'package:flutter/material.dart';

class Pantalla{

  ///return screen size. (porcentaje, contexto, eje(y: alto, x:ancho))
  static double getPorcentPanntalla(double porcentaje, BuildContext context, String eje){

    if(eje == 'y'){
      return (porcentaje/100) * (MediaQuery.of(context).size.height);
    }
    return (porcentaje/100) * (MediaQuery.of(context).size.width);

  }
}