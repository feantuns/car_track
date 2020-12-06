import 'package:car_track/actions/actions.dart';
import 'package:car_track/components/followed_pieces.dart';
import 'package:car_track/components/title_carousel.dart';
import 'package:car_track/models/app_state.dart';
import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:car_track/locator.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

@immutable
class HomeScreenViewModel {
  final User user;
  final Function onTapCar;
  final List piecesNeedingRepair;
  final bool logged;

  HomeScreenViewModel(
      {this.user, this.onTapCar, this.piecesNeedingRepair, this.logged});
}

class HomeScreen extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, HomeScreenViewModel>(
        builder: (context, HomeScreenViewModel viewModel) {
      var cars = FirebaseFirestore.instance
          .collection('users/' + viewModel.user.uid + '/cars')
          .orderBy('maisUsado', descending: true);

      // TODO fazer uma funcao que retorna o primeiro nome do usuario
      var userName = viewModel.user.displayName;

      if (userName.contains(" ")) {
        userName = userName.substring(0, userName.indexOf(" "));
      }

      return StreamBuilder<QuerySnapshot>(
          stream: cars.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()));
            }

            var data = snapshot.data.docs;

            return Scaffold(
              body: SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[350],
                      padding: EdgeInsets.fromLTRB(16, 50, 0, 100),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Olá, $userName',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54),
                                ),
                                IconButton(
                                  onPressed: () => _navigationService
                                      .navigateTo(routes.SettingsRoute),
                                  icon: Icon(
                                    Icons.settings_outlined,
                                    color: Colors.grey[700],
                                    size: 24.0,
                                    semanticLabel: 'Configurações',
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: 0, maxHeight: 170),
                            child: Container(
                              child: new FollowedPieces(
                                  onlyNeedingRepair: true,
                                  onlyMostUsedCar: true),
                            ),
                          ),
                          Container(
                            child: data.length > 0
                                ? new TitleCarousel(
                                    items: snapshot.data.docs,
                                    title: 'Seus veículos',
                                    scaleImg: 2,
                                    imagePath: 'assets/half_car.png',
                                    onTap: (id) => viewModel.onTapCar(id))
                                : Text(
                                    'Vamos começar com o cadastro de um novo veículo',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0.0, -72.0),
                      child: Card(
                        elevation: 6,
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: InkWell(
                            splashColor: Colors.grey.withAlpha(30),
                            onTap: () => _navigationService
                                .navigateTo(routes.NewCar1Route),
                            child: Container(
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image:
                                          new AssetImage('assets/half_car.png'),
                                      fit: BoxFit.none,
                                      alignment: Alignment(1.0, -0.5)),
                                ),
                                padding: EdgeInsets.all(12),
                                height: 170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'Novo veículo',
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }, converter: (store) {
      return new HomeScreenViewModel(
          user: store.state.firebaseUser,
          piecesNeedingRepair: store.state.piecesNeedingRepair,
          logged: store.state.logged,
          onTapCar: (String carId) {
            store.dispatch(new SelectedCarIdAction(carId));
            _navigationService.navigateTo(routes.CarDetailsRoute);
          });
    });
  }
}
