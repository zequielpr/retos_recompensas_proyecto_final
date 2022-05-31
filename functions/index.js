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
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/{followerUid}`.
 * Users save their device notification tokens to `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */

const db = admin.firestore();

exports.createUserEuropean = functions.region('europe-west1')
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

      respuesta = await admin.messaging().sendToDevice(post.tokens, payload);
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
              const deleteTask = await documento.update({ tokens: admin.firestore.FieldValue.arrayRemove(tokens[index]) }); //Borrar token obsoleto
            tokensDelete.push(deleteTask);
          }
        }
      });
      return Promise.all(tokensDelete);
    }
  });//final de metodo


//------------------------------------------------------------------------------------------------------

/*exports.createUser = functions.firestore
  .document('/usuarios/{tutorId}/rolTutor/{idSala}/misiones/{idMision}')
  .onCreate(async (snap, context) => {

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

      respuesta = await admin.messaging().sendToDevice(post.tokens, payload);
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
              const deleteTask = await documento.update({ tokens: admin.firestore.FieldValue.arrayRemove(tokens[index]) }); //Borrar token obsoleto
            tokensDelete.push(deleteTask);
          }
        }
      });
      return Promise.all(tokensDelete);
    }


  });//final de metodo*/

