import 'package:car_track/actions/actions.dart';
import 'package:car_track/models/app_state.dart';
import 'package:car_track/screens/car_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

@immutable
class FollowPieceCongratsViewModel {
  final Function resetState;

  FollowPieceCongratsViewModel({this.resetState});
}

class FollowPieceCongratsScreen extends StatelessWidget {
  FollowPieceCongratsScreen({Key key, this.carId}) : super(key: key);

  final String carId;

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
                    'Agora fique de olho nas notificações',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 60),
                  Center(
                      child: Image(image: AssetImage("assets/congrats.png"))),
                  SizedBox(height: 40),
                  Text(
                    'Vamos te avisar quando você precisar dar manutenção para esta peça',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 30),
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
      return new FollowPieceCongratsViewModel(resetState: () {
        store.dispatch(new ResetStateFollowPieceAction());

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarDetailsScreen()),
        );
      });
    });
  }
}
