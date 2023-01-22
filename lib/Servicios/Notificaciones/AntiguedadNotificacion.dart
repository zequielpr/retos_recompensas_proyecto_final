import '../../recursos/DateActual.dart';

class AntiguedadNotificaciones{
  static String getAntiguedad( fecha_solicitu){
    DateTime fechaActual = DateActual.dateActual;
    dynamic tiempo = fechaActual.millisecondsSinceEpoch -
        fecha_solicitu.millisecondsSinceEpoch;
    var divisores = [1000, 60, 60, 24];
    var contador = 0;
    var unidadTiempo;

    divisores.forEach((element) {
      if (tiempo > element) {
        if (contador == 2 && element == 24) return;
        contador++;
        tiempo = tiempo / element;
      }
    });

    tiempo = tiempo.round();
    switch (contador) {
      case 1:
        unidadTiempo = tiempo > 1 ? '$tiempo segundos': '$tiempo segundo';
        break;
      case 2:
        unidadTiempo = tiempo > 1 ? '$tiempo minutos': '$tiempo minuto';
        break;
      case 3:
        unidadTiempo = tiempo > 1 ? '$tiempo horas': '$tiempo hora';
        break;
      case 4:
        unidadTiempo = tiempo > 1 ? '$tiempo días': '$tiempo día';
        break;
      default:
        unidadTiempo = 'un momento';
        break;
    }

    return unidadTiempo;
  }
}