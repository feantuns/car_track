import 'package:flutter/material.dart';
import 'package:car_track/actions/actions.dart';
import 'package:car_track/models/app_state.dart';
import 'package:car_track/locator.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';

@immutable
class SettingsScreenViewModel {
  final User user;
  final bool logged;
  final Function signOut;

  SettingsScreenViewModel({this.user, this.signOut, this.logged});
}

class SettingsScreen extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, SettingsScreenViewModel>(
        builder: (context, SettingsScreenViewModel viewModel) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 32,
                left: 10,
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        viewModel.user.photoURL,
                      ),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(height: 40),
                    Text(
                      'NOME',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      viewModel.user.displayName,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'EMAIL',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      viewModel.user.email,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 40),
                    OutlineButton(
                      onPressed: () {
                        viewModel.signOut();
                      },
                      borderSide: BorderSide(width: 1.0, color: Colors.red),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(13, 12, 13, 12),
                        child: Text(
                          'SAIR',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }, converter: (store) {
      return new SettingsScreenViewModel(
          user: store.state.firebaseUser,
          logged: store.state.logged,
          signOut: () => store.dispatch(new SignOutUserAction()));
    });
  }
}
