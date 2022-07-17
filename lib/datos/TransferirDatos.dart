import 'package:cloud_firestore/cloud_firestore.dart';
import 'SalaDatos.dart';

//Transferir datos a las ruta login
class TransferirDatosLogin {
  final CollectionReference collectionReferenceUser;
  TransferirDatosLogin(this.collectionReferenceUser);
}

class TransferirDatos {
  final String nombreSala;
  final SalaDatos sala;
  final CollectionReference collecionUsuarios;

  TransferirDatos(this.nombreSala, this.sala, this.collecionUsuarios);
}

class TransferirDatosMisiones {
  final CollectionReference collectionReferenceMisiones;

  TransferirDatosMisiones(this.collectionReferenceMisiones);
}

class TranferirDatosRoll {
  final dynamic oaUthCredential;
  final CollectionReference collectionReferenceUsers;

  TranferirDatosRoll(this.oaUthCredential, this.collectionReferenceUsers);
}

class TrasnferirDatosNombreUser {
  final dynamic oaUthCredential;
  final String dropdownValue;
  final String userName;
  final CollectionReference collectionReferenceUsers;

  TrasnferirDatosNombreUser(this.oaUthCredential, this.dropdownValue,
      this.userName, this.collectionReferenceUsers);
}


class TransferirDatosInicio{
  final bool isTutorado;
  TransferirDatosInicio(this.isTutorado);
}
