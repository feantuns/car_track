import 'package:car_track/components/box_title.dart';
import 'package:car_track/components/followed_pieces.dart';
import 'package:car_track/components/pieces.dart';
import 'package:car_track/locator.dart';
import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:car_track/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:car_track/models/app_state.dart';

@immutable
class CarDetailsViewModel {
  final User user;
  final String carId;

  CarDetailsViewModel({this.user, this.carId});
}

class CarDetailsScreen extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, CarDetailsViewModel>(
        builder: (context, CarDetailsViewModel viewModel) {
      CollectionReference cars = FirebaseFirestore.instance
          .collection('users/' + viewModel.user.uid + '/cars/');

      return FutureBuilder<DocumentSnapshot>(
          future: cars.doc(viewModel.carId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()));
            }

            var data = snapshot.data.data();

            return new Scaffold(
                body: Builder(
              builder: (context) => SingleChildScrollView(
                  child: Stack(
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                    Container(
                        height: 280,
                        color: Colors.grey[350],
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Image(
                                image: AssetImage("assets/half_car_big.png")))),
                    Transform.translate(
                      offset: const Offset(0.0, -50.0),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 8),
                            Text(data['nome'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700])),
                            SizedBox(height: 8),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: BoxTitle(
                                      title: 'Marca',
                                      subtitle: data['marca'],
                                    ),
                                  ),
                                  Expanded(
                                    child: BoxTitle(
                                        title: 'Modelo',
                                        subtitle: data['modelo']),
                                  )
                                ]),
                            if (data['maisUsado']) ...[
                              SizedBox(height: 24),
                              Row(children: <Widget>[
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 30.0,
                                ),
                                SizedBox(width: 8),
                                Text("Este é o seu carro mais usado",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey[700]))
                              ]),
                            ],
                            SizedBox(height: 24),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(minHeight: 0, maxHeight: 170),
                              child: Container(
                                child: FollowedPieces(
                                  onlyNeedingRepair: true,
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(minHeight: 0, maxHeight: 170),
                              child: Container(
                                child: FollowedPieces(
                                  onlyNeedingRepair: false,
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(minHeight: 0, maxHeight: 170),
                              child: Container(
                                child: Pieces(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  Positioned(
                    top: 32,
                    left: 8,
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.grey[700],
                        size: 32.0,
                        semanticLabel: 'Voltar',
                      ),
                      onPressed: () =>
                          _navigationService.navigateTo(routes.HomeRoute),
                    ),
                  ),
                ],
              )),
            ));
          });
    }, converter: (store) {
      return new CarDetailsViewModel(
          user: store.state.firebaseUser, carId: store.state.selectedCarId);
    });
  }
}
