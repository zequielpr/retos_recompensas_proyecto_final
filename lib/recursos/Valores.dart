import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Valores{
  static AppLocalizations? valores;

  static setValores(BuildContext context){
    valores = AppLocalizations.of(context);
  }
}