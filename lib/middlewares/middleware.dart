import 'package:car_track/actions/actions.dart';
import 'package:car_track/models/app_state.dart';
import 'package:car_track/models/follow_piece.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

firebaseMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  final User currentUser = _auth.currentUser;

  if (action is InitAction) {
    if (currentUser != null) {
      store.dispatch(new UserLoadedAction(currentUser));
      store.dispatch(new GetPiecesNeedingRepairAction());
    }
  }
  if (action is SignInUserAction) {
    if (store.state.firebaseUser == null) {
      final User currentUser = _auth.currentUser;

      if (currentUser != null) {
        store.dispatch(new UserLoadedAction(currentUser));
      } else {
        final GoogleSignInAccount googleSignInAccount =
            await googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User user = authResult.user;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        store.dispatch(new UserLoadedAction(user));
      }
    }
  }

  if (action is CreateNewCarAction) {
    store.dispatch(new ShowNewCarLoadingAction());

    CollectionReference userCars = FirebaseFirestore.instance
        .collection('users/' + currentUser.uid + '/cars');

    userCars.add(action.novoCarro.toJson()).then((value) {
      print("Car Added");
      store.dispatch(new SuccesfullyCreatedCarAction());
    }).catchError((error) => print("Error: $error"));
  }

  if (action is FollowPieceAction) {
    store.dispatch(new ShowFollowPieceLoadingAction());

    CollectionReference followedPieces = FirebaseFirestore.instance
        .collection('users/' + currentUser.uid + '/followedPieces');
    CollectionReference pieces =
        FirebaseFirestore.instance.collection('pieces');

    var piece = await pieces.doc(action.followPiece.pieceId).get();

    final String pieceName = piece.data()['nome'];

    // Logica para determinar se peca precisa de manutencao
    final int diasParaManutencao = piece.data()['diasParaManutencao'];
    final DateTime now = DateTime.now();
    final int diffNowUltimaManutencao =
        now.difference(action.followPiece.ultimaManutencao).inDays;
    final bool precisaManutencao =
        diffNowUltimaManutencao >= diasParaManutencao;

    final FollowPiece updatedPieceToFollow = action.followPiece
        .copyWith(nome: pieceName, precisaManutencao: precisaManutencao);

    followedPieces.add(updatedPieceToFollow.toJson()).then((value) {
      print("Piece Followed");
      store.dispatch(new SuccesfullyFollowedPieceAction());
    }).catchError((error) => print("Error: $error"));
  }

  if (action is GetPiecesNeedingRepairAction) {
    var mostUsedCarRef = FirebaseFirestore.instance
        .collection('users/' + currentUser.uid + '/cars')
        .where("maisUsado", isEqualTo: true);

    var mostUsedCar = await mostUsedCarRef.get();

    if (mostUsedCar.docs.length > 0) {
      var piecesNeedingRepairRef = FirebaseFirestore.instance
          .collection('users/' + currentUser.uid + '/followedPieces')
          .where("carId", isEqualTo: mostUsedCar.docs[0].id)
          .where("precisaManutencao", isEqualTo: true);

      store.dispatch(new MostUsedCarIdAction(mostUsedCar.docs[0].id));

      var piecesNeedingRepair = await piecesNeedingRepairRef.get();

      print(piecesNeedingRepair.docs);

      store.dispatch(
          new UpdatePiecesNeedingRepairAction(piecesNeedingRepair.docs));
    }
  }
  next(action);
}
