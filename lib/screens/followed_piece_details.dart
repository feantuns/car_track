import 'package:car_track/actions/actions.dart';
import 'package:car_track/components/box_title.dart';
import 'package:car_track/locator.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:car_track/models/app_state.dart';

@immutable
class FollowedPieceDetailsViewModel {
  final User user;
  final List piecesNeedingRepair;
  final Function getPiecesNeedingRepair;

  FollowedPieceDetailsViewModel(
      {this.user, this.piecesNeedingRepair, this.getPiecesNeedingRepair});
}

class FollowedPieceDetailsScreen extends StatefulWidget {
  FollowedPieceDetailsScreen({Key key, this.itemId}) : super(key: key);

  final String itemId;

  _FollowedPieceDetailsState createState() =>
      _FollowedPieceDetailsState(itemId: itemId);
}

class _FollowedPieceDetailsState extends State<FollowedPieceDetailsScreen> {
  _FollowedPieceDetailsState({this.itemId});

  final String itemId;
  final NavigationService _navigationService = locator<NavigationService>();

  bool loading = true;
  bool getDetails = true;
  var followedPiece;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FollowedPieceDetailsViewModel>(
        builder: (context, FollowedPieceDetailsViewModel viewModel) {
      CollectionReference pieces =
          FirebaseFirestore.instance.collection('pieces');
      CollectionReference followedPieces = FirebaseFirestore.instance
          .collection('users/' + viewModel.user.uid + '/followedPieces');

      Future getFollowedPiece() {
        return followedPieces
            .doc(itemId)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          setState(() {
            followedPiece = documentSnapshot.data();
            loading = false;
            getDetails = false;
          });
        });
      }

      Future<void> fizManutencao() {
        return followedPieces.doc(itemId).update({
          'precisaManutencao': false,
          'ultimaManutencao': new DateTime.now()
        }).then((value) {
          getFollowedPiece();
          viewModel.getPiecesNeedingRepair();
        }).catchError((error) => print('error: $error'));
      }

      Future<void> unfollowPiece() {
        return followedPieces
            .doc(itemId)
            .delete()
            .then((value) => _navigationService.goBack())
            .catchError((error) => print("error: $error"));
      }

      if (getDetails) {
        getFollowedPiece();
      }

      if (loading) {
        return Container(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()));
      }

      return FutureBuilder<DocumentSnapshot>(
          future: pieces.doc(followedPiece['pieceId']).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()));
            }

            var data = snapshot.data.data();

            // Logica para conseguir data da proxima manutencao
            final int diasParaManutencao = data['diasParaManutencao'];
            final DateTime ultimaManutencao =
                new DateTime.fromMillisecondsSinceEpoch(
                    followedPiece['ultimaManutencao'].seconds * 1000);
            final DateTime proxManutencao =
                ultimaManutencao.add(new Duration(days: diasParaManutencao));
            final int dia = proxManutencao.day;
            final int mes = proxManutencao.month;

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
                            Text('Status',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700])),
                            SizedBox(height: 12),
                            if (followedPiece['precisaManutencao']) ...[
                              BoxTitle(
                                title: 'Peça precisa de manutenção',
                                titleSize: 20,
                                subtitle:
                                    'Com manutenção pendente desde $dia/$mes',
                                subtitleSize: 16,
                              )
                            ],
                            if (!followedPiece['precisaManutencao']) ...[
                              BoxTitle(
                                title: 'Peça com manutenção em dia',
                                titleSize: 20,
                                subtitle: 'Próxima manutenção em $dia/$mes',
                                subtitleSize: 16,
                              )
                            ],
                            SizedBox(height: 80),
                            if (followedPiece['precisaManutencao']) ...[
                              SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                      onPressed: () {
                                        fizManutencao();
                                      },
                                      color: Colors.deepPurpleAccent[700],
                                      padding:
                                          EdgeInsets.fromLTRB(13, 12, 13, 12),
                                      child: Text('FIZ A MANUTENÇÃO',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)))),
                              SizedBox(height: 8),
                            ],
                            SizedBox(
                                width: double.infinity,
                                child: OutlineButton(
                                    onPressed: () => unfollowPiece(),
                                    borderSide: BorderSide(
                                        width: 1.0,
                                        color: Colors.deepPurpleAccent[700]),
                                    padding:
                                        EdgeInsets.fromLTRB(13, 12, 13, 12),
                                    child: Text('DEIXAR DE ACOMPANHAR PEÇA',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.deepPurpleAccent[700]))))
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
      return new FollowedPieceDetailsViewModel(
          user: store.state.firebaseUser,
          getPiecesNeedingRepair: () =>
              store.dispatch(new GetMostUsedCarAction()),
          piecesNeedingRepair: store.state.piecesNeedingRepair);
    });
  }
}
