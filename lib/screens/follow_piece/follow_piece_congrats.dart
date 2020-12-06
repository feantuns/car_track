import 'package:car_track/actions/actions.dart';
import 'package:car_track/models/app_state.dart';
import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:car_track/locator.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

@immutable
class FollowPieceCongratsViewModel {
  final Function resetState;
  final bool allowNotification;

  FollowPieceCongratsViewModel({this.resetState, this.allowNotification});
}

class FollowPieceCongratsScreen extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FollowPieceCongratsViewModel>(
        builder: (context, FollowPieceCongratsViewModel viewModel) {
      return new Scaffold(
          body: Builder(
        builder: (context) => Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 32.0, right: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Parabéns!',
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 16),
                  Text(
                    viewModel.allowNotification
                        ? 'Agora fique de olho nas notificações'
                        : 'Agora você está acompanhando esta peça',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 50),
                  Center(
                      child: Image(image: AssetImage("assets/congrats.png"))),
                  SizedBox(height: 40),
                  Text(
                    viewModel.allowNotification
                        ? 'Vamos te avisar quando esta peça precisar de manutenção'
                        : 'Acompanhe seu status na tela de detalhes do veículo',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: RaisedButton(
                        onPressed: () {
                          viewModel.resetState();
                        },
                        color: Colors.deepPurpleAccent[700],
                        padding: EdgeInsets.fromLTRB(13, 12, 13, 12),
                        child: Text('ÓTIMO',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ),
                ],
              ),
            )),
      ));
    }, converter: (store) {
      return new FollowPieceCongratsViewModel(
          resetState: () {
            store.dispatch(new ResetStateFollowPieceAction());
            _navigationService.navigateTo(routes.CarDetailsRoute);
          },
          allowNotification: store.state.allowNotification);
    });
  }
}
