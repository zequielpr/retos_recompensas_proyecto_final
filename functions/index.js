/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
"use strict";

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { firestore } = require("firebase-admin");
admin.initializeApp();
/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/{followerUid}`.
 * Users save their device notification tokens to `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */

const db = admin.firestore();

/*
export const createUserEuropean = region('europe-west1')
  .firestore
  .document('/usuarios/{tutorId}/rolTutor/{idSala}/misiones/{idMision}')
  .onCreate(async (snap, context) => {
    // Get an object representing the document
    // e.g. {'name': 'Marie', 'age': 66}

 const tutorId = context.params.tutorId;
    const idSala = context.params.idSala;

    const usuariosRef = db.collection('usuarios');
    const snapshot = await usuariosRef.doc(tutorId).collection('rolTutor').doc(idSala).collection('usersTutorados').get();
    if (snapshot.empty) {
      console.log('No matching documents.');
      return;
    }

    var docUsuario = ''
    var post = '';
    var respuesta = '';
    var docUParametro = '';
    var snapShotUsuariosTutorados = '';

    const payload = {
      notification: {
        title: 'Nueva misión',
        body: 'Leer',
        icon: 'https://imborrable.com/wp-content/uploads/2021/04/fotos-gratis-de-stock-1.jpg'
      }
    };

    //El bucle forEach debe ser asíncrono ya que debe esperar a que la consulta se realice y continuar con la ejecución
    snapshot.forEach(async doc => {
      docUsuario = usuariosRef.doc(doc.id.trim());
      snapShotUsuariosTutorados = await docUsuario.get();
      console.log('Id de usuario encontrado:*',doc.id,'*')
      post = snapShotUsuariosTutorados.data();
      console.log('Tokens encontrados: ', post);
      //await usuariosRef.doc(doc.id).update({tokens: admin.firestore.FieldValue.arrayRemove(token)}); //Borrar token de un array

      respuesta = await messaging().sendToDevice(post.tokens, payload);
      await cleanupTokens(respuesta, post.tokens, docUsuario);
    });

    //Funcion para eliminar todos los tokens que no tengan ningun dispositivo asosciado
    async function cleanupTokens(response, tokens, documento) {
      const tokensDelete = [];
      response.results.forEach(async (result, index) => {
        const error = result.error;
        if (error) {
          console.error('Failure sending notification to', tokens[index], error);
          // Cleanup the tokens who are not registered anymore.
          if (error.code === 'messaging/invalid-registration-token' ||
            error.code === 'messaging/registration-token-not-registered') {
              const deleteTask = await documento.update({ tokens: firestore.FieldValue.arrayRemove(tokens[index]) }); //Borrar token obsoleto
            tokensDelete.push(deleteTask);
          }
        }
      });
      return Promise.all(tokensDelete);
    }
  });//final de metodo
*/

//------------------------------------------------------------------------------------------------------

exports.notificarNuevaMision = functions.firestore
  .document("/usuarios/{tutorId}/rolTutor/{tutorId_contenodor}/salas/{idSala}/misiones/{idMision}")
  .onCreate(async (snap, context) => {
    const tutorId = context.params.tutorId;
    const idSala = context.params.idSala;
    const nombreMision = snap.data()['nombreMision'];
    const idMision = context.params.idMision;

    //Toma todos los usuario que se encuentran en la sala en la cual se ha creado una nueva misión
    const usuariosRef = db.collection("usuarios");
    const snapshot = await usuariosRef
      .doc(tutorId)
      .collection("rolTutor").doc(tutorId)
      .collection('salas').doc(idSala).collection('usersTutorados')
      .get();
    if (snapshot.empty) {
      console.log("No matching documents.");
      return;
    }

    var nombreTutor;
    var nombreSala;

    await usuariosRef
      .doc(tutorId)
      .get()
      .then((snap) => {
        nombreTutor = snap.data()["nombre"];
      });

    await usuariosRef
      .doc(tutorId)
      .collection("rolTutor").doc(tutorId)
      .collection('salas')
      .doc(idSala)
      .get()
      .then((snap) => { nombreSala = snap.data()['NombreSala'] });

    var docUsuario = "";
    var post = "";
    var respuesta = "";
    var docUParametro = "";
    var snapShotUsuariosTutorados = "";

    const payload = {
      notification: {
        title: "Nueva misión",
        body: nombreTutor + "ha añadido una nueva mision",
        icon: "https://imborrable.com/wp-content/uploads/2021/04/fotos-gratis-de-stock-1.jpg",
      },
    };

    //El bucle forEach debe ser asíncrono ya que debe esperar a que la consulta se realice y continuar con la ejecución
    snapshot.forEach(async (doc) => {
      docUsuario = usuariosRef.doc(doc.id.trim());


      //Comprobar si el buzon existe
      if (docUsuario
        .collection("notificaciones")) {

      }

      //Ecribir la notificación en el buzón del usuario
      await docUsuario
        .collection("notificaciones")
        .doc(doc.id.trim())
        .collection("misiones_recibidas")
        .add({
          id_emisor: tutorId,
          id_sala: idSala,
          nombre_tutor: nombreTutor,
          nombre_sala: nombreSala,
          isNew: true,
          idMision: idMision,
          nombre_mision: nombreMision,
        });

      await docUsuario
        .collection("notificaciones")
        .doc(doc.id.trim())
        .update({ nueva_mision: true }); //Actualizar numero de notificaciones misiones
      await docUsuario
        .collection("notificaciones")
        .doc(doc.id.trim())
        .update({ numb_misiones: admin.firestore.FieldValue.increment(1) }); //Actualizar numero de notificaciones misiones



      snapShotUsuariosTutorados = await docUsuario.get();
      console.log("Id de usuario encontrado:*", doc.id, "*");
      post = snapShotUsuariosTutorados.data();
      console.log("Tokens encontrados: ", post);
      //await usuariosRef.doc(doc.id).update({tokens: admin.firestore.FieldValue.arrayRemove(token)}); //Borrar token de un array
      respuesta = await admin.messaging().sendToDevice(post.tokens, payload);
      await cleanupTokens(respuesta, post.tokens, docUsuario);
    });

    //Funcion para eliminar todos los tokens que no tengan ningun dispositivo asosciado
    async function cleanupTokens(response, tokens, documento) {
      const tokensDelete = [];
      response.results.forEach(async (result, index) => {
        const error = result.error;
        if (error) {
          console.error(
            "Failure sending notification to",
            tokens[index],
            error
          );
          // Cleanup the tokens who are not registered anymore.
          if (
            error.code === "messaging/invalid-registration-token" ||
            error.code === "messaging/registration-token-not-registered"
          ) {
            const deleteTask = await documento.update({
              tokens: admin.firestore.FieldValue.arrayRemove(tokens[index]),
            }); //Borrar token obsoleto
            tokensDelete.push(deleteTask);
          }
        }
      });
      return Promise.all(tokensDelete);
    }
  }); //final de metodo

//Notificar solicitud________________________________________________________________________________________________
exports.notificarSolicitudesRecibidas = functions.firestore
  .document(
    "/usuarios/{userId}/notificaciones/{userId2}/solicitudesRecibidas/{idSolicitud}"
  )
  .onCreate(async (snap, context) => {
    var nuevaSolicitud = snap.data();

    var user_id = context.params.userId;
    var nombre_emisor = nuevaSolicitud.nombre_emisor;

    //Obtener documento de usuaro al cual se le ha enviado la solicitud
    var documentUser = db.collection("usuarios").doc(user_id.trim());

    await documentUser
      .collection("notificaciones")
      .doc(user_id.trim())
      .update({ nueva_solicitud: true }); //Actualizar numero de notificaciones solicitudes
    await documentUser
      .collection("notificaciones")
      .doc(user_id.trim())
      .update({ numb_solicitudes: admin.firestore.FieldValue.increment(1) }); //Actualizar numero de notificaciones solicitudes

    //Crea la notificacion
    const payload = {
      notification: {
        title: "Solicitud de tutoría",
        body: nombre_emisor + " te ha enviado una solicitud de tutoría",
        icon: "https://imborrable.com/wp-content/uploads/2021/04/fotos-gratis-de-stock-1.jpg",
      },
    };

    //Obtiene los tokens del usuario que se le ha enviado la solicitud y se le envia la notificación
    await documentUser.get().then(async (snap) => {
      var tokens = snap.data().tokens;

      //console.log("Tokens encontrados: ", tokens);
      var respuesta = await admin.messaging().sendToDevice(tokens, payload);
      await cleanupTokens(respuesta, tokens, documentUser);
    });

    //Funcion para eliminar todos los tokens que no tengan ningun dispositivo asosciado
    //Funcion para eliminar todos los tokens que no tengan ningun dispositivo asosciado
    async function cleanupTokens(response, tokens, documento) {
      const tokensDelete = [];
      response.results.forEach(async (result, index) => {
        const error = result.error;
        if (error) {
          console.error(
            "Failure sending notification to",
            tokens[index],
            error
          );
          // Cleanup the tokens who are not registered anymore.
          if (
            error.code === "messaging/invalid-registration-token" ||
            error.code === "messaging/registration-token-not-registered"
          ) {
            const deleteTask = await documento.update({
              tokens: admin.firestore.FieldValue.arrayRemove(tokens[index]),
            }); //Borrar token obsoleto
            tokensDelete.push(deleteTask);
          }
        }
      });
      return Promise.all(tokensDelete);
    }
  }); //final de metodo


//Eliminar usuario_____________________________________--
exports.eliminarUsuario = functions.firestore.document("usuarios/{UID}").onDelete(async (snap, context) => {
  console.log('Inicia la funcion para eliminar al tutor');
  const isTutorado = snap.data()['rol_tutorado'];
  const idRemoveUser = context.params.UID;
  var usuarios = db.collection('usuarios');



  if (isTutorado == true) {
    await eliminarDatosTutorado();
  } else {
    console.log('elimina las relaciones con dicho tutor');
    await elimiDatosUsuarioTutor();
  }



  //Eliminar datos del usuario tutorado___________________________________________________-
  async function eliminarDatosTutorado() {
    var idTutor;
    snap.ref.collection('rolTutorado').get().then(async (snap) => {
      snap.docs.forEach(async (doc) => {
        idTutor = doc.id;
        await eliminarIdUserTutuorado(idTutor);
        await elimUserDeSalas(idTutor)
      })
    });
  }

  //Eliminar idRemoveUser de usuario tutor
  async function eliminarIdUserTutuorado(idTutor) {
    await usuarios.doc(idTutor).collection('rolTutor').doc(idTutor).
      collection('allUsersTutorados').doc('usuarios_tutorados').
      update({ 'idUserTotorado': firestore.FieldValue.arrayRemove([idRemoveUser]) })
  }

  //Eliminar usuario tutorado de todas las salas
  async function elimUserDeSalas(idTutor) {
    await usuarios.doc(idTutor).collection('rolTutor').doc(idTutor).
      collection('salas').get().then((snap) => {
        snap.docs.forEach(async (doc) => {
          await doc.ref.collection('usersTutorados').doc(idRemoveUser).delete();
        })
      });
  }


  //Eliminar datos del usuario tutor_________________________________________________
  //Elimina el avance que el usuario tutorado tuvo con el tutor que borra los datos
  async function elimiDatosUsuarioTutor() {
    var usuarioTutorado = [];

    await snap.ref.collection('rolTutor').doc(idRemoveUser).
      collection('allUsersTutorados').doc('usuarios_tutorados').get().then((snap) => {
        usuarioTutorado = snap.data()['idUserTotorado'];
      });


    usuarioTutorado.forEach(async (idUserTutorado) => {
      await usuarios.doc(idUserTutorado).collection('rolTutorado').doc(idRemoveUser).delete();
    });
  }

});