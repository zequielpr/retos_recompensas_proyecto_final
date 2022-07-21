import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../datos/TransferirDatos.dart';
import '../../widgets/Cards.dart';

//Store this globally
final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class ListaMisiones extends StatefulWidget {
  static final ROUTE_NAME = '/ListaMisiones';
  const ListaMisiones({Key? key}) : super(key: key);
  @override
  _ListaMisionesState createState() => _ListaMisionesState();
}

class _ListaMisionesState extends State<ListaMisiones> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TransferirDatos;
    CollectionReference collectionReferenceMisiones =
        args.sala.docSala.collection('misiones');
    return Scaffold(
      appBar: AppBar(
        title: Text(args.nombreSala),
      ),
      body: StreamBuilder(
        stream: collectionReferenceMisiones.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Cards.getCardMision(
                    documentSnapshot['nombreMision'],
                    documentSnapshot['objetivoMision'],
                    documentSnapshot['completada_por'],
                    documentSnapshot['solicitu_confirmacion'], currentUser?.uid as String, context, documentSnapshot.reference, 0, 0);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
