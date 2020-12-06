import 'package:car_track/actions/actions.dart';
import 'package:car_track/models/app_state.dart';
import 'package:car_track/models/follow_piece.dart';
import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:car_track/locator.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

firebaseMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  final User currentUser = _auth.currentUser;
  final NavigationService _navigationService = locator<NavigationService>();

  if (action is InitAction) {
    if (currentUser != null) {
      store.dispatch(new UserLoadedAction(currentUser));
      store.dispatch(new GetMostUsedCarAction());
      store.dispatch(new GetAllowNotificationAction());
      _navigationService.navigateTo(routes.HomeRoute);
    }
  }
  if (action is SignInUserAction) {
    if (!store.state.logged) {
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

      store.dispatch(new UserLoadedAction(user));

      _navigationService.navigateTo(routes.HomeRoute);
    }
  }

  if (action is SignOutUserAction) {
    await googleSignIn.signOut();
    await _auth.signOut();
    store.dispatch(new RemoveUserAction());
    _navigationService.navigateTo(routes.LoginRoute);
  }

  if (action is CreateNewCarAction) {
    store.dispatch(new ShowNewCarLoadingAction());

    CollectionReference userCars =
        firestore.collection('users/' + currentUser.uid + '/cars');

    userCars.add(action.novoCarro.toJson()).then((value) {
      store.dispatch(new SuccesfullyCreatedCarAction());
      store.dispatch(new GetMostUsedCarAction());
      _navigationService.navigateTo(routes.NewCarCongratsRoute);
    }).catchError((error) => print("Error: $error"));
  }

  if (action is FollowPieceAction) {
    store.dispatch(new ShowFollowPieceLoadingAction());

    CollectionReference followedPieces =
        firestore.collection('users/' + currentUser.uid + '/followedPieces');
    CollectionReference pieces = firestore.collection('pieces');

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
      store.dispatch(new SuccesfullyFollowedPieceAction());
      _navigationService.navigateTo(routes.FollowPieceCongratsRoute);
    }).catchError((error) => print("Error: $error"));
  }

  if (action is GetMostUsedCarAction) {
    var mostUsedCarRef = firestore
        .collection('users/' + currentUser.uid + '/cars')
        .where("maisUsado", isEqualTo: true);

    var mostUsedCar = await mostUsedCarRef.get();

    if (mostUsedCar.docs.length > 0) {
      store.dispatch(new MostUsedCarIdAction(mostUsedCar.docs[0].id));
    }
  }

  if (action is GetAllowNotificationAction) {
    var tokenRef =
        firestore.collection('users/' + currentUser.uid + '/info').doc('token');
    bool allowNotification = false;

    tokenRef.get().then((doc) {
      if (doc.exists) {
        allowNotification = true;
      }

      print(allowNotification);

      store.dispatch(new SetAllowNotificationAction(allowNotification));
    });
  }

  next(action);
}
