import 'package:car_track/actions/actions.dart';
import 'package:car_track/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

firebaseMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is InitAction) {
    final User currentUser = _auth.currentUser;

    print(currentUser.uid);

    if (currentUser != null) {
      store.dispatch(new UserLoadedAction(currentUser));
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
  next(action);
}
