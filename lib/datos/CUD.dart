import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/Fields.dart';

class CUD{


  static void crearMision(idDocMision, CollectionReference collectionReferenceMisiones, BuildContext context, String accion  ) async {




    double pading_left = 10.0;
    double pading_top = 5.0;
    double pading_right = 10.0;
    double pading_bottom = 10.0;
    String hint = "nombre de misión";
    bool oculto = false;

    var nombreMision =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto);
    var objetivo =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto);
    var recompensaMision =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto);
    var tipo =  Fields(pading_left, pading_top, pading_right, pading_bottom, hint, oculto);


    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
      return Padding(
        padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            // prevent the soft keyboard from covering text fields
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ListTile(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                leading: Material(
                  color: Colors.transparent,
                  child: InkWell(

                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back) // the arrow back icon
                  ),
                ),
                title: Center(
                  child: Text('Prueba', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),), // Your desired title
                )
            ),
            SizedBox(
              height: 194,
              child: ListView(
                children: [
                  nombreMision.getInstance,
                  objetivo.getInstance,
                  recompensaMision.getInstance,
                  tipo.getInstance,



                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(accion == 'guardar' ? 'Guardar' : 'Modificar'),
                    onPressed: () async {
                      //final String? name = _tituloController.text;

                      if (nombreMision.getValor != null ) {
                        if (accion == 'guardar') {
                          // Persist a new product to Firestore
                          collectionReferenceMisiones.add({'fecha': DateTime.now(), 'nombreMision': nombreMision.getValor, 'objetivo': objetivo.getValor, 'recompensaMision': recompensaMision.getValor, 'tipo': tipo.getValor });
                          //await CollecionUsuarios.doc('bjLOKYGnq8FOIuzUkQLD').collection('rolTutor').add({"NombreSala": name, 'numMisiones': 0, 'numTutorados': 0});
                        }


                        if (accion == 'Modificar') {
                          // Update the product
                          await collectionReferenceMisiones
                              .doc(idDocMision)
                              .update({"NombreSala": nombreMision.getValor, });
                        }



                      }else{

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Rellene todos los campos. El precio debe ser un número entero')));
                      }
                      // Hide the bottom sheet
                      Navigator.of(context).pop();

                    },
                  )
                ],
              ),
            )


          ],
        ),
      );
    });

  }




}