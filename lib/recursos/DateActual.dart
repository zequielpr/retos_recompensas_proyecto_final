import 'package:ntp/ntp.dart';

class DateActual {
  static var fechaInicial;
  static var offset;
  static var dateActual;
  static Future<DateTime> getActualDateTime() async {
    fechaInicial = DateTime.now().toLocal();
    offset = await NTP.getNtpOffset(localTime: fechaInicial);
    dateActual = fechaInicial.add(Duration(milliseconds: offset));
    return dateActual;
  }
}
