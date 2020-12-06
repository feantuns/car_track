import 'package:car_track/actions/actions.dart';
import 'package:car_track/models/follow_piece.dart';
import 'package:car_track/locator.dart';
import 'package:car_track/push_notifications.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:car_track/models/app_state.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

@immutable
class FollowPieceViewModel {
  final Function followPieceAction;
  final Function getAllowNotificationStatus;
  final FollowPiece followPiece;
  final String carId;
  final bool isLoading;
  final bool followedPiece;
  final bool allowNotification;

  FollowPieceViewModel(
      {this.followPieceAction,
      this.followPiece,
      this.isLoading,
      this.allowNotification,
      this.getAllowNotificationStatus,
      this.followedPiece,
      this.carId});
}

class FollowPieceScreen extends StatefulWidget {
  FollowPieceScreen({Key key, this.pieceId}) : super(key: key);

  final String pieceId;

  _FollowPieceState createState() => _FollowPieceState(pieceId: pieceId);
}

class _FollowPieceState extends State<FollowPieceScreen> {
  _FollowPieceState({this.pieceId});

  final String pieceId;
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationsManager push = new PushNotificationsManager();

  DateTime selectedDate;
  bool allowNotificationLocal = false;
  Function followPiece;
  FollowPiece piece;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FollowPieceViewModel>(
        builder: (context, FollowPieceViewModel viewModel) {
      Future<void> _showMyDialog() async {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Notificações'),
              content: Text('Deseja receber notificações?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      viewModel.followPieceAction(new FollowPiece(
                          pieceId: pieceId,
                          carId: viewModel.carId,
                          ultimaManutencao: selectedDate));
                    },
                    child: Text('NÃO')),
                TextButton(
                  child: Text('SIM'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      allowNotificationLocal = true;
                    });
                    viewModel.followPieceAction(new FollowPiece(
                        pieceId: pieceId,
                        carId: viewModel.carId,
                        ultimaManutencao: selectedDate));
                  },
                ),
              ],
            );
          },
        );
      }

      return new Scaffold(
          body: Builder(
        builder: (context) => Container(
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16, 90, 30, 24),
                  color: Colors.grey[350],
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Legal :)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                      SizedBox(height: 10),
                      Text(
                          'Nos conte quando foi a última vez que deu manutenção nessa peça.',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700])),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 80),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: DateTimeField(
                        format: DateFormat("dd/MM/yyyy"),
                        decoration: InputDecoration(
                          labelText: 'Data da última manutenção',
                          filled: true,
                        ),
                        onChanged: (dt) {
                          setState(() => selectedDate = dt);
                          print('Selected date: $selectedDate');
                        },
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                      ),
                    ),
                  ],
                ),
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
                Positioned(
                  bottom: 32,
                  right: 16,
                  child: RaisedButton(
                    onPressed: () {
                      if (selectedDate != null) {
                        if (viewModel.allowNotification) {
                          viewModel.followPieceAction(new FollowPiece(
                              pieceId: pieceId,
                              carId: viewModel.carId,
                              ultimaManutencao: selectedDate));
                        } else {
                          _showMyDialog();
                        }
                      } else {
                        final snackBar =
                            SnackBar(content: Text('Preencha o campo!'));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                    color: Colors.deepPurpleAccent[700],
                    padding: EdgeInsets.fromLTRB(13, 12, 13, 12),
                    child: Row(
                      children: <Widget>[
                        Text('AVANÇAR',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 8),
                        (viewModel.isLoading != null && viewModel.isLoading)
                            ? Container(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 24.0,
                              ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ));
    }, converter: (store) {
      return new FollowPieceViewModel(
          followPieceAction: (FollowPiece followPiece) {
            store.dispatch(new FollowPieceAction(followPiece));
            if (allowNotificationLocal) {
              push.init();
              store.dispatch(new SetAllowNotificationAction(true));
            }
          },
          isLoading: store.state.isLoadingFollowPiece,
          followedPiece: store.state.createdFollowPiece,
          carId: store.state.selectedCarId,
          allowNotification: store.state.allowNotification,
          getAllowNotificationStatus: () =>
              store.dispatch(new GetAllowNotificationAction()));
    });
  }
}
