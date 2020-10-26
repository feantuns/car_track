import 'package:car_track/models/car.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitAction {}

class SignInUserAction {}

class UserLoadedAction {
  final User firebaseUser;
  UserLoadedAction(this.firebaseUser);
}

class UpdateNewCarAction {
  final Car novoCarro;
  UpdateNewCarAction(this.novoCarro);
}

class CreateNewCarAction {
  final Car novoCarro;
  CreateNewCarAction(this.novoCarro);
}

class ShowNewCarLoadingAction {}

class HideNewCarLoadingAction {}
