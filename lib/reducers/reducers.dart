import 'package:car_track/models/app_state.dart';
import 'package:car_track/actions/actions.dart';

AppState stateReducer(AppState state, action) {
  if (action is UserLoadedAction) {
    return state.copyWith(firebaseUser: action.firebaseUser);
  }

  if (action is UpdateNewCarAction) {
    return state.copyWith(novoCarro: action.novoCarro, createdNewCar: false);
  }

  if (action is CreateNewCarAction) {
    return state.copyWith(novoCarro: action.novoCarro);
  }

  if (action is ShowNewCarLoadingAction) {
    return state.copyWith(isLoadingNewCar: true);
  }

  if (action is HideNewCarLoadingAction) {
    return state.copyWith(isLoadingNewCar: false);
  }

  if (action is SuccesfullyCreatedCarAction) {
    return state.copyWith(isLoadingNewCar: false, createdNewCar: true);
  }

  if (action is SelectedCarIdAction) {
    return state.copyWith(selectedCarId: action.carId);
  }

  if (action is ShowFollowPieceLoadingAction) {
    return state.copyWith(isLoadingFollowPiece: true);
  }

  if (action is SuccesfullyFollowedPieceAction) {
    return state.copyWith(
        isLoadingFollowPiece: false, createdFollowPiece: true);
  }

  if (action is ResetStateFollowPieceAction) {
    return state.copyWith(createdFollowPiece: false, followPiece: null);
  }

  if (action is UpdatePiecesNeedingRepairAction) {
    return state.copyWith(piecesNeedingRepair: action.piecesNeedingRepair);
  }

  if (action is MostUsedCarIdAction) {
    return state.copyWith(mostUsedCarId: action.mostUsedCarId);
  }

  return state;
}
