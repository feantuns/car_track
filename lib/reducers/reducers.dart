import 'package:car_track/models/app_state.dart';
import 'package:car_track/actions/actions.dart';

AppState stateReducer(AppState state, action) {
  if (action is UserLoadedAction) {
    return state.copyWith(firebaseUser: action.firebaseUser);
  }

  if (action is UpdateNewCarAction) {
    return state.copyWith(novoCarro: action.novoCarro);
  }

  if (action is ShowNewCarLoadingAction) {
    return state.copyWith(isLoadingNewCar: true);
  }

  if (action is HideNewCarLoadingAction) {
    return state.copyWith(isLoadingNewCar: false);
  }

  return state;
}
