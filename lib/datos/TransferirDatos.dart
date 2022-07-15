import 'package:cloud_firestore/cloud_firestore.dart';
import 'SalaDatos.dart';

class TransferirDatos {
  final String nombreSala;
  final SalaDatos sala;
  final CollectionReference collecionUsuarios;

  TransferirDatos(this.nombreSala, this.sala, this.collecionUsuarios);
}

class TransferirDatosMisiones{
  final CollectionReference collectionReferenceMisiones;

  TransferirDatosMisiones(this.collectionReferenceMisiones);
}
