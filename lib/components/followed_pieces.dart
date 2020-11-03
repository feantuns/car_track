import 'package:car_track/components/title_carousel.dart';
import 'package:car_track/screens/follow_piece/follow_piece.dart';
import 'package:car_track/screens/followed_piece_details.dart';
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
  FollowedPieces({Key key, this.onlyNeedingRepair}) : super(key: key);

  final bool onlyNeedingRepair;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FollowedPiecesViewModel>(
        builder: (context, FollowedPiecesViewModel viewModel) {
      var pieces = FirebaseFirestore.instance
          .collection('users/' + viewModel.user.uid + '/followedPieces')
          .where("precisaManutencao", isEqualTo: onlyNeedingRepair);

      if (viewModel.carId != null) {
        pieces = pieces.where("carId", isEqualTo: viewModel.carId);
      } else {
        pieces = pieces.where("carId", isEqualTo: viewModel.mostUsedCarId);
      }

      return StreamBuilder<QuerySnapshot>(
          stream: pieces.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()));
            }

            var data = snapshot.data.docs;

            if (data.length > 0) {
              return Container(
                margin: EdgeInsets.only(bottom: 24),
                child: TitleCarousel(
                    scaleImg: 2,
                    items: snapshot.data.docs,
                    title: onlyNeedingRepair
                        ? 'Tá na hora de trocar'
                        : 'Peças em acompanhamento',
                    imagePath: 'assets/piece.png',
                    onTap: (id) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FollowedPieceDetailsScreen(
                                    itemId: id,
                                  )),
                        )),
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
