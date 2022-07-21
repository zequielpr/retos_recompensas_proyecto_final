import 'package:cloud_firestore/cloud_firestore.dart';
import 'SalaDatos.dart';

//Transferir datos a las ruta login
class TransferirCollecion {
  final CollectionReference collectionReferenceUser;
  TransferirCollecion(this.collectionReferenceUser);
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

class TransfDatosUserTutorado{
  final CollectionReference collectionReferenceMisiones;
  final DocumentSnapshot snap;

  TransfDatosUserTutorado(this.collectionReferenceMisiones, this.snap);
}

class TranferirDatosRoll {
  final dynamic oaUthCredential;
  final CollectionReference collectionReferenceUsers;

  TranferirDatosRoll(this.oaUthCredential, this.collectionReferenceUsers);
}

class TransDatosInicioSesion{
  final String titulo;
  final bool focusEmail;
  final bool focusPassw;
  final String email;
  final CollectionReference collectionReferenceUsers;

  TransDatosInicioSesion(this.titulo, this.focusEmail, this.focusPassw, this.email, this.collectionReferenceUsers);
}


class TrasnferirDatosNombreUser {
  late  dynamic oaUthCredential;
  final String dropdownValue;
  late  String userName;
  final CollectionReference collectionReferenceUsers;

  TrasnferirDatosNombreUser(this.oaUthCredential, this.dropdownValue,
      this.userName, this.collectionReferenceUsers);

  setValor(String clave, String valor){

    oaUthCredential[clave] = valor;

  }

  setUserName(String userName){
    this.userName = userName;
  }
}



class TransferirDatosInicio{
  final bool isTutorado;
  TransferirDatosInicio(this.isTutorado);
}

