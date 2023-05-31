import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../recursos/DateActual.dart';

class AntiguedadNotificaciones {
  static String getAntiguedad(fecha_solicitu, AppLocalizations? valores) {
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
        unidadTiempo = tiempo > 1
            ? '${valores?.hace_es} $tiempo ${valores?.segundo}${valores?.s} ${valores?.hace}'
            : '${valores?.hace_es} $tiempo ${valores?.segundo} ${valores?.hace}';
        break;
      case 2:
        unidadTiempo = tiempo > 1
            ? '${valores?.hace_es} $tiempo ${valores?.minuto}${valores?.s} ${valores?.hace}'
            : '${valores?.hace_es} $tiempo ${valores?.minuto} ${valores?.hace}';
        break;
      case 3:
        unidadTiempo = tiempo > 1
            ? '${valores?.hace_es} $tiempo ${valores?.hora}${valores?.s} ${valores?.hace}'
            : '${valores?.hace_es} $tiempo ${valores?.hora} ${valores?.hace}';
        break;
      case 4:
        unidadTiempo = tiempo > 1
            ? '${valores?.hace_es} $tiempo ${valores?.dia}${valores?.s} ${valores?.hace}'
            : '${valores?.hace_es} $tiempo ${valores?.dia} ${valores?.hace}';
        break;
      default:
        unidadTiempo = '${valores?.un_momento}';
        break;
    }

    return unidadTiempo;
  }
}
