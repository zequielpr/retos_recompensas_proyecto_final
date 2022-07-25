import 'package:flutter/material.dart';

class Pantalla{

  ///(Devuelve un porcentaje del tamaño de la pantalla. (porcentaje, contexto, eje(y: largo, x:ancho))
  static double getPorcentPanntalla(double porcentaje, BuildContext context, String eje){

    if(eje == 'y'){
      return (porcentaje/100) * (MediaQuery.of(context).size.height);
    }
    return (porcentaje/100) * (MediaQuery.of(context).size.width);

  }
}