import 'package:ntp/ntp.dart';

class DateActual {
  static var _fechaInicial;
  static var _offset;
  static var _dateActual;
  static Future<DateTime> getActualDateTime() async {
    _fechaInicial = DateTime.now().toLocal();
    _offset = await NTP.getNtpOffset(localTime: _fechaInicial);
    _dateActual = _fechaInicial.add(new Duration(milliseconds: _offset));
    return _dateActual;
  }
}
