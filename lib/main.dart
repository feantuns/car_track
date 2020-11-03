import 'package:car_track/middlewares/middleware.dart';
import 'package:car_track/actions/actions.dart';
import 'package:car_track/reducers/reducers.dart';
import 'package:car_track/screens/home.dart';
import 'package:car_track/screens/login.dart';
import 'package:car_track/screens/new_car/new_car_1.dart';
import 'package:car_track/screens/new_car/new_car_2.dart';
import 'package:car_track/screens/new_car/new_car_3.dart';
import 'package:car_track/screens/new_car/new_car_congrats.dart';
import 'package:car_track/screens/new_car/new_car_details.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:car_track/models/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CarTrack());
}

class CarTrack extends StatelessWidget {
  final Store store = new Store<AppState>(stateReducer,
      initialState: new AppState.initial(),
      middleware: [firebaseMiddleware].toList());

  @override
  Widget build(BuildContext context) {
    store.dispatch(new InitAction());
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Track',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return store.state.firebaseUser == null
                ? new LoginScreen()
                : new HomeScreen();
          },
          '/new-car-1': (BuildContext context) {
            return new NewCar1Screen();
          },
          '/new-car-2': (BuildContext context) {
            return new NewCar2Screen();
          },
          '/new-car-3': (BuildContext context) {
            return new NewCar3Screen();
          },
          '/new-car-details': (BuildContext context) {
            return new NewCarDetailsScreen();
          },
          '/new-car-congrats': (BuildContext context) {
            return new NewCarCongratsScreen();
          }
        },
      ),
    );
  }
}
