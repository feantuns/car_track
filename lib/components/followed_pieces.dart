import 'package:car_track/components/title_carousel.dart';
import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:car_track/locator.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:car_track/models/app_state.dart';

@immutable
class FollowedPiecesViewModel {
  final User user;
  final String carId;
  final String mostUsedCarId;

  FollowedPiecesViewModel({this.user, this.carId, this.mostUsedCarId});
}

class FollowedPieces extends StatelessWidget {
  FollowedPieces(
      {Key key, this.onlyNeedingRepair, this.onlyMostUsedCar = false})
      : super(key: key);

  final bool onlyNeedingRepair;
  final bool onlyMostUsedCar;
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FollowedPiecesViewModel>(
        builder: (context, FollowedPiecesViewModel viewModel) {
      var pieces = FirebaseFirestore.instance
          .collection('users/' + viewModel.user.uid + '/followedPieces')
          .where("precisaManutencao", isEqualTo: onlyNeedingRepair);

      if (onlyMostUsedCar) {
        pieces = pieces.where("carId", isEqualTo: viewModel.mostUsedCarId);
      } else {
        pieces = pieces.where("carId", isEqualTo: viewModel.carId);
      }

      return StreamBuilder<QuerySnapshot>(
          stream: pieces.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                '',
              );
            }

            var data = snapshot.data.docs;

            if (data.length > 0) {
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TitleCarousel(
                    scaleImg: 3,
                    showDot: onlyNeedingRepair ? true : false,
                    items: snapshot.data.docs,
                    title: onlyNeedingRepair
                        ? 'Está na hora de trocar'
                        : 'Peças em acompanhamento',
                    imagePath: 'assets/piece.png',
                    onTap: (id) => _navigationService.navigateTo(
                        routes.FollowedPieceDetailsRoute,
                        arguments: id)),
              );
            }

            return Text(
              '',
            );
          });
    }, converter: (store) {
      return new FollowedPiecesViewModel(
          user: store.state.firebaseUser,
          carId: store.state.selectedCarId,
          mostUsedCarId: store.state.mostUsedCarId);
    });
  }
}
