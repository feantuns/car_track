import 'package:car_track/locator.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:car_track/models/app_state.dart';

@immutable
class PieceDetailsViewModel {
  final User user;

  PieceDetailsViewModel({this.user});
}

class PieceDetailsScreen extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  PieceDetailsScreen({Key key, this.pieceId}) : super(key: key);

  final String pieceId;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, PieceDetailsViewModel>(
        builder: (context, PieceDetailsViewModel viewModel) {
      CollectionReference pieces =
          FirebaseFirestore.instance.collection('pieces');

      return FutureBuilder<DocumentSnapshot>(
          future: pieces.doc(pieceId).get(),
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
                  Column(children: <Widget>[
                    Container(
                        height: 280,
                        color: Colors.grey[350],
                        child: Align(
                            alignment: Alignment.centerRight,
                            child:
                                Image(image: AssetImage("assets/piece.png")))),
                    Transform.translate(
                      offset: const Offset(0.0, -55.0),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(data['nome'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700])),
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Text(data['descricao'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[700])),
                            ),
                            SizedBox(height: 30),
                            Text('Como faço isso?',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700])),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Text(data['ajuda'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[700])),
                            ),
                            SizedBox(height: 80),
                            SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                    onPressed: () => _navigationService
                                        .navigateTo(routes.FollowPieceRoute,
                                            arguments: pieceId),
                                    color: Colors.deepPurpleAccent[700],
                                    padding:
                                        EdgeInsets.fromLTRB(13, 12, 13, 12),
                                    child: Text('ACOMPANHAR PEÇA',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))))
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
                      onPressed: () => _navigationService.goBack(),
                    ),
                  ),
                ],
              )),
            ));
          });
    }, converter: (store) {
      return new PieceDetailsViewModel(user: store.state.firebaseUser);
    });
  }
}
