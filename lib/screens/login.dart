import 'package:car_track/screens/home.dart';
import 'package:car_track/actions/actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:car_track/models/app_state.dart';

@immutable
class LoginScreenViewModel {
  final Function signInUser;
  final User user;

  LoginScreenViewModel({this.signInUser, this.user});
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, LoginScreenViewModel>(
        builder: (context, LoginScreenViewModel viewModel) {
      print(viewModel.user);
      if (viewModel.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }

      return new Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('assets/background_login.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 50),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Image(
                              image: AssetImage("assets/half_car_big.png"))),
                      SizedBox(height: 50),
                      Padding(
                          padding: new EdgeInsets.all(25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Olá",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 53),
                                  textAlign: TextAlign.left),
                              SizedBox(height: 5),
                              Text("Entre com uma conta do Google",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 15),
                                  textAlign: TextAlign.left),
                            ],
                          ))
                    ]),
              ),
              SizedBox(height: 50),
              _signInButton(context, viewModel.signInUser),
            ],
          ),
        ),
      );
    }, converter: (store) {
      return new LoginScreenViewModel(
          signInUser: () => store.dispatch(new SignInUserAction()),
          user: store.state.firebaseUser);
    });
  }

  Widget _signInButton(BuildContext context, Function signInUser) {
    return RaisedButton(
      splashColor: Colors.grey,
      onPressed: () => signInUser(),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      highlightElevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Entrar com o Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
