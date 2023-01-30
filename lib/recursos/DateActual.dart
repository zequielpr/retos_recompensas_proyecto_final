import 'package:ntp/ntp.dart';

class DateActual {
  static var fechaInicial;
  static var offset;
  static var dateActual = DateTime.now();
  static Future<DateTime> getActualDateTime() async {
    fechaInicial = DateTime.now().toLocal();
    offset = await NTP.getNtpOffset(localTime: fechaInicial).catchError((onError){});
    dateActual = fechaInicial.add(Duration(milliseconds: offset));
    print('holaaa');
    return dateActual;
  }
}
