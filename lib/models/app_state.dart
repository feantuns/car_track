import 'package:car_track/models/car.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final User firebaseUser;
  final Car novoCarro;
  final bool isLoadingNewCar;
  final bool createdNewCar;

  AppState(
      {this.firebaseUser,
      this.novoCarro,
      this.isLoadingNewCar,
      this.createdNewCar});

  factory AppState.initial() => AppState(
      firebaseUser: null,
      novoCarro: null,
      isLoadingNewCar: false,
      createdNewCar: false);

  AppState copyWith(
      {User firebaseUser,
      Car novoCarro,
      bool isLoadingNewCar,
      bool createdNewCar}) {
    return new AppState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        novoCarro: novoCarro ?? this.novoCarro,
        isLoadingNewCar: isLoadingNewCar ?? this.isLoadingNewCar,
        createdNewCar: createdNewCar ?? this.createdNewCar);
  }
}
