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

  TransferirDatos(this.nombreSala, this.sala);
}

class TransferirDatosMisiones {
  final CollectionReference collectionReferenceMisiones;

  TransferirDatosMisiones(this.collectionReferenceMisiones);
}

class TransfDatosUserTutorado {
  final CollectionReference collectionReferenceMisiones;
  final DocumentSnapshot snap;

  TransfDatosUserTutorado(this.collectionReferenceMisiones, this.snap);
}

class TranferirDatosRoll {
  final dynamic oaUthCredential;

  TranferirDatosRoll(this.oaUthCredential);
}

class TransDatosInicioSesion {
  final String titulo;
  final bool focusEmail;
  final bool focusPassw;
  final String email;

  TransDatosInicioSesion(this.titulo, this.focusEmail, this.focusPassw,
      this.email);
}

class TrasnferirDatosNombreUser {
  late String userName;
  late final CollectionReference collectionReferenceUsers;
  late dynamic oaUthCredential;
  late String dropdownValue;
  TrasnferirDatosNombreUser(this.oaUthCredential, this.dropdownValue, this.userName, this.collectionReferenceUsers);

  TrasnferirDatosNombreUser.SoloNombre(this.userName);

  setValor(String clave, String valor) {
    oaUthCredential[clave] = valor;
  }

  setUserName(String userName) {
    this.userName = userName;
  }
}

class TransferirDatosInicio {
  final bool isTutorado;
  TransferirDatosInicio(this.isTutorado);
}

//Comenzando a llamar a las clases auxiliares como herlpers
