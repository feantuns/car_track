const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

const auth = admin.auth();

exports.scheduledFunctionCrontab = functions.pubsub
  .schedule('00 00 * * *')
  .timeZone('America/Sao_Paulo') // Users can choose timezone - default is America/Los_Angeles
  .onRun(context => {
    return auth.listUsers().then(result => {
      result.users.forEach(user => {
        const userId = user.uid;
        const followedPiecesRef = db.collection(
          `users/${userId}/followedPieces`
        );

        followedPiecesRef.get().then(followedPieces => {
          if (followedPieces.empty) {
            return null;
          } else {
            followedPieces.forEach(doc => {
              const pieceId = doc.data()['pieceId'];
              const ultimaManutencao = new Date(
                doc.data()['ultimaManutencao']._seconds * 1000
              );

              const now = new Date();

              const diffInTime = now.getTime() - ultimaManutencao.getTime();

              const diffInDays = diffInTime / (1000 * 3600 * 24);

              const pieceRef = db.collection('pieces').doc(pieceId);

              pieceRef.get().then(piece => {
                const daysToChange = piece.data()['diasParaManutencao'];

                if (diffInDays > daysToChange) {
                  let batch = db.batch();
                  batch.update(doc.ref, { precisaManutencao: true });
                  return batch.commit();
                }
              });
            });
          }
        });
      });
    });
  });

exports.sendNotifications = functions.pubsub
  .schedule('10 17 * * *')
  .timeZone('America/Sao_Paulo') // Users can choose timezone - default is America/Los_Angeles
  .onRun(context => {
    return auth.listUsers().then(result => {
      result.users.forEach(user => {
        const userId = user.uid;
        const followedPiecesRef = db.collection(
          `users/${userId}/followedPieces`
        );

        followedPiecesRef.get().then(followedPieces => {
          if (followedPieces.empty) {
            return null;
          } else {
            followedPieces.forEach(followedPiece => {
              const precisaManutencao = followedPiece.data()[
                'precisaManutencao'
              ];

              if (precisaManutencao) {
                const tokenRef = db
                  .collection(`users/${userId}/info`)
                  .doc('token');

                tokenRef.get().then(doc => {
                  if (doc.exists) {
                    const token = doc.data()['token'];

                    const payload = {
                      notification: {
                        title: `A peça ${
                          followedPiece.data()['nome']
                        } precisa de manutenção`,
                        body: 'Clique para ver',
                        sound: 'default',
                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                      },
                      data: {
                        carId: followedPiece.data()['carId'],
                      },
                    };

                    return admin
                      .messaging()
                      .sendToDevice([token], payload)
                      .then(response => {
                        response.results.forEach((result, index) => {
                          const error = result.error;
                          if (error) {
                            console.error('Algo deu errado', error);
                          } else {
                            console.log('Notificação enviada com sucesso!');
                          }
                        });
                      });
                  } else {
                    return null;
                  }
                });
              }
            });
          }
        });
      });
    });
  });

exports.verifyOnlyOneMostUsedCar = functions.firestore
  .document('users/{userId}/cars/{carId}')
  .onCreate((snap, context) => {
    const { userId, carId } = context.params;
    const newValue = snap.data();

    const userCarsRef = db.collection(`users/${userId}/cars`);

    if (!newValue.maisUsado) {
      return null;
    }

    return userCarsRef.get().then(querySnapshot => {
      if (querySnapshot.empty) {
        return null;
      } else {
        let batch = db.batch();

        querySnapshot.forEach(doc => {
          console.log(doc, doc.data()['maisUsado'], doc.id, carId);
          if (doc.data()['maisUsado'] && doc.id !== carId) {
            batch.update(doc.ref, { maisUsado: false });
          }
        });

        return batch.commit();
      }
    });
  });
