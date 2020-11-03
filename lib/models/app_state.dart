import 'package:car_track/models/car.dart';
import 'package:car_track/models/follow_piece.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

// TODO: learn how to combine states to prevent this file growing big
@immutable
class AppState {
  final User firebaseUser;
  final Car novoCarro;
  final bool isLoadingNewCar;
  final bool createdNewCar;
  final FollowPiece followPiece;
  final bool isLoadingFollowPiece;
  final bool createdFollowPiece;
  final String selectedCarId;
  final String mostUsedCarId;
  final List piecesNeedingRepair;
  final Object selectedFollowedPiece;

  AppState(
      {this.firebaseUser,
      this.novoCarro,
      this.isLoadingNewCar,
      this.followPiece,
      this.isLoadingFollowPiece,
      this.createdFollowPiece,
      this.createdNewCar,
      this.selectedCarId,
      this.selectedFollowedPiece,
      this.mostUsedCarId,
      this.piecesNeedingRepair});

  factory AppState.initial() => AppState(
        firebaseUser: null,
        novoCarro: null,
        isLoadingNewCar: false,
        createdNewCar: false,
        followPiece: null,
        isLoadingFollowPiece: false,
        createdFollowPiece: false,
        selectedCarId: null,
        piecesNeedingRepair: null,
        selectedFollowedPiece: null,
        mostUsedCarId: null,
      );

  AppState copyWith(
      {User firebaseUser,
      Car novoCarro,
      bool isLoadingNewCar,
      bool createdNewCar,
      FollowPiece followPiece,
      bool isLoadingFollowPiece,
      String selectedCarId,
      String mostUsedCarId,
      Object selectedFollowedPiece,
      List piecesNeedingRepair,
      bool createdFollowPiece}) {
    return new AppState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        novoCarro: novoCarro ?? this.novoCarro,
        isLoadingNewCar: isLoadingNewCar ?? this.isLoadingNewCar,
        createdNewCar: createdNewCar ?? this.createdNewCar,
        followPiece: followPiece ?? this.followPiece,
        isLoadingFollowPiece: isLoadingFollowPiece ?? this.isLoadingFollowPiece,
        createdFollowPiece: createdFollowPiece ?? this.createdFollowPiece,
        selectedCarId: selectedCarId ?? this.selectedCarId,
        mostUsedCarId: mostUsedCarId ?? this.mostUsedCarId,
        selectedFollowedPiece:
            selectedFollowedPiece ?? this.selectedFollowedPiece,
        piecesNeedingRepair: piecesNeedingRepair ?? this.piecesNeedingRepair);
  }
}
