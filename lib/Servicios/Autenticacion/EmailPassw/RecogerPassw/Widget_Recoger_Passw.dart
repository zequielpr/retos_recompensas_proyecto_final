import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';

import '../../../../Rutas.gr.dart';
import '../../../../datos/TransferirDatos.dart';
import '../../../../datos/UsuarioActual.dart';
import '../../../../datos/ValidarDatos.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Widget_Recoger_Passw {
  BuildContext _context;
  AppLocalizations? _valores;
  TrasnferirDatosNombreUser _args;
  var _setState;
  bool _isSignUp;

  static void setPasswController(){
    _passwController.text = '';
  }

  Widget_Recoger_Passw(
      this._context, this._valores, this._args, this._setState, this._isSignUp);

  static final _passwController = TextEditingController();
  static var _botoActivado = false;
  static var _cumpleLongitud = false;
  static var _longValid = false;
  static var _letraNumValid = false;

  static var _iconPassw = Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
  static var _passwOculta = true;
  static Icon _iconoLogitud = const Icon(
    Icons.circle_outlined,
    size: 20,
    color: Colors.grey,
  );
  static Icon _iconoLetrasN = Icon(
    Icons.circle_outlined,
    size: 20,
    color: Colors.grey,
  );

  Widget getTextFieldPasswd() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: Pantalla.getPorcentPanntalla(4, _context, 'y')),
            child: Text(
              _valores?.establece_passw as String,
              style:
                  GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        TextField(
          maxLength: 16,
          keyboardType: TextInputType.visiblePassword,
          controller: _passwController,
          onChanged: (passw) {
            //_setState((){_passwController.text = passw;});
            passw.length >= 8
                ? passw.length <= 16
                    ? _checkLongitud(true)
                    : _checkLongitud(false)
                : _checkLongitud(false);
            Validar.validarPassw(passw) == true
                ? _checkLetrasNumb(true)
                : _checkLetrasNumb(false);
          },
          obscureText: _passwOculta,
          autofocus: true,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () =>
                    _passwOculta == true ? _mostrarPassw() : _ocultarPassw(),
                icon: _iconPassw,
              ),
              border: OutlineInputBorder(),
              labelText: _valores?.passw),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              _iconoLogitud,
              Text(
                _valores?.requisito_1_passw as String,
                style: GoogleFonts.roboto(fontSize: 15),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              _iconoLetrasN,
              Text(_valores?.requisito_2_passw as String,
                  style: GoogleFonts.roboto(fontSize: 15))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: Pantalla.getPorcentPanntalla(2, _context, 'y')),
          child: SizedBox(
              width: Pantalla.getPorcentPanntalla(50, _context, 'x'),
              height: Pantalla.getPorcentPanntalla(6, _context, 'y'),
              child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                  onPressed: _botoActivado
                      ? () {
                          if (_isSignUp) {
                            _continuar(_args, _passwController.text);
                          }else{
                            _changePasswd(_passwController.text);
                          }
                        }
                      : null,
                  child: Text(
                    _isSignUp?'${_valores?.boton_next_p_1}':'${_valores?.guardar}',
                    style: GoogleFonts.roboto(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ))),
        ),
      ],
    );
  }

  void _mostrarPassw() {
    _passwOculta = false;
    _iconPassw = Icon(
      Icons.visibility,
      color: Colors.grey,
    );
    _setState(() {});
  }

  void _ocultarPassw() {
    _passwOculta = true;
    _iconPassw = Icon(
      Icons.visibility_off,
      color: Colors.grey,
    );
    _setState(() {});
  }

  void _checkLongitud(bool isValid) {
    _setState(() {
      if (isValid) {
        _iconoLogitud = Icon(
          Icons.check_circle,
          size: 20,
          color: Colors.green,
        );
        _longValid = true;
        return;
      }
      _longValid = false;
      _iconoLogitud = Icon(
        Icons.circle_outlined,
        size: 20,
        color: Colors.grey,
      );
      ;
    });
  }

  void _checkLetrasNumb(bool isValid) {
    _setState(() {
      if (isValid) {
        _iconoLetrasN = const Icon(
          Icons.check_circle,
          size: 20,
          color: Colors.green,
        );
        if (_longValid) {
          _botoActivado = true;
          return;
        }
        _botoActivado = false;
        return;
      }
      _botoActivado = false;
      _iconoLetrasN = const Icon(
        Icons.circle_outlined,
        size: 20,
        color: Colors.grey,
      );
    });
  }

  void _continuar(TrasnferirDatosNombreUser args, passw) {
    args.setValor('passw', passw);
    _context.router.push(NombreUsuarioRouter(args: args));
  }

  _changePasswd(String newPassword) {
    const snackBar = SnackBar(
      content: Text('Contraseña actualizada'),
    );
    (CurrentUser.currentUser?.updatePassword(newPassword))
        ?.catchError((onError) {})
        .then((value) => _context.router.pop().then(
            (value) => ScaffoldMessenger.of(_context).showSnackBar(snackBar)));
  }
}
