import 'package:car_track/models/car.dart';
import 'package:car_track/models/follow_piece.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitAction {}

class SignInUserAction {}

class SignOutUserAction {}

class UserLoadedAction {
  final User firebaseUser;
  UserLoadedAction(this.firebaseUser);
}

class RemoveUserAction {}

class UpdateNewCarAction {
  final Car novoCarro;
  UpdateNewCarAction(this.novoCarro);
}

class CreateNewCarAction {
  final Car novoCarro;
  CreateNewCarAction(this.novoCarro);
}

class SelectedCarIdAction {
  final String carId;
  SelectedCarIdAction(this.carId);
}

class MostUsedCarIdAction {
  final String mostUsedCarId;
  MostUsedCarIdAction(this.mostUsedCarId);
}

class FollowPieceAction {
  final FollowPiece followPiece;
  FollowPieceAction(this.followPiece);
}

class ShowNewCarLoadingAction {}

class HideNewCarLoadingAction {}

class SuccesfullyCreatedCarAction {}

class ShowFollowPieceLoadingAction {}

class SuccesfullyFollowedPieceAction {}

class ResetStateFollowPieceAction {}

class GetMostUsedCarAction {}

class GetAllowNotificationAction {}

class SetAllowNotificationAction {
  final bool allowNotification;
  SetAllowNotificationAction(this.allowNotification);
}

class GetFollowedPieceAction {
  final String id;
  GetFollowedPieceAction(this.id);
}

class FizManutencaoAction {}

class UpdateFollowedPieceAction {
  final Object followedPiece;
  UpdateFollowedPieceAction(this.followedPiece);
}

class UpdatePiecesNeedingRepairAction {
  final List piecesNeedingRepair;
  UpdatePiecesNeedingRepairAction(this.piecesNeedingRepair);
}
