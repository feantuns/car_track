import 'package:car_track/middlewares/middleware.dart';
import 'package:car_track/actions/actions.dart';
import 'package:car_track/reducers/reducers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:car_track/locator.dart';
import 'package:car_track/router.dart' as router;
import 'package:car_track/services/navigation_service.dart';
import 'package:car_track/models/app_state.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CarTrack());
}

class CarTrack extends StatefulWidget {
  @override
  _CarTrackState createState() => new _CarTrackState();
}

class _CarTrackState extends State<CarTrack> {
  final Store store = new Store<AppState>(stateReducer,
      initialState: new AppState.initial(),
      middleware: [firebaseMiddleware].toList());

  final NavigationService _navigationService = locator<NavigationService>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _navigateToCarDetail(Map<String, dynamic> message) {
    final String carId = message['data']['carId'];
    print(message);
    print(carId);
    store.dispatch(new SelectedCarIdAction(carId));
    _navigationService.navigateTo(routes.CarDetailsRoute);
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        _navigateToCarDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _navigateToCarDetail(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => store.dispatch(new InitAction()));
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Track',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: router.generateRoute,
        initialRoute: routes.LoginRoute,
      ),
    );
  }
}
