import 'dart:ffi';

import 'package:flutter/material.dart';

class Fields {
  double _pading_left;
  double _pading_top;
  double _pading_right;
  double _pading_bottom;
  String? _hint;
  bool oculto;
  int maxLine;
  Color bakgroud;
  bool filled;
  Widget field = TextField();
  final TextEditingController controller = TextEditingController();

  Fields(
      this._pading_left,
      this._pading_top,
      this._pading_right,
      this._pading_bottom,
      this._hint,
      this.oculto,
      this.maxLine,
      this.bakgroud,
      this.filled) {
    field = Padding(
      padding: EdgeInsets.fromLTRB(
          _pading_left, _pading_top, _pading_right, _pading_bottom),
      child: TextField(
        controller: controller,
        maxLines: maxLine,
        obscureText: oculto,
        decoration: InputDecoration(
          fillColor: bakgroud,
          filled: filled,
          border: const OutlineInputBorder(),
          labelText: _hint,
        ),
      ),
    );
  }

  //Obtener el objeto
  Widget get getInstance => field;

  //Devuelve el contenido del field
  String get getValor => controller.text;
}
