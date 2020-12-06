import 'package:car_track/screens/car_details.dart';
import 'package:car_track/screens/follow_piece/follow_piece.dart';
import 'package:car_track/screens/follow_piece/follow_piece_congrats.dart';
import 'package:car_track/screens/followed_piece_details.dart';
import 'package:car_track/screens/new_car/new_car_1.dart';
import 'package:car_track/screens/new_car/new_car_2.dart';
import 'package:car_track/screens/new_car/new_car_3.dart';
import 'package:car_track/screens/new_car/new_car_congrats.dart';
import 'package:car_track/screens/new_car/new_car_details.dart';
import 'package:car_track/screens/piece_details.dart';
import 'package:car_track/screens/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:car_track/screens/home.dart';
import 'package:car_track/screens/login.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.LoginRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());

    case routes.HomeRoute:
      return MaterialPageRoute(builder: (context) => HomeScreen());

    case routes.SettingsRoute:
      return MaterialPageRoute(builder: (context) => SettingsScreen());

    case routes.CarDetailsRoute:
      return MaterialPageRoute(builder: (context) => CarDetailsScreen());

    case routes.NewCar1Route:
      return MaterialPageRoute(builder: (context) => NewCar1Screen());

    case routes.NewCar2Route:
      return MaterialPageRoute(builder: (context) => NewCar2Screen());

    case routes.NewCar3Route:
      return MaterialPageRoute(builder: (context) => NewCar3Screen());

    case routes.NewCarDetailsRoute:
      return MaterialPageRoute(builder: (context) => NewCarDetailsScreen());

    case routes.NewCarCongratsRoute:
      return MaterialPageRoute(builder: (context) => NewCarCongratsScreen());

    case routes.PieceDetailsRoute:
      var pieceId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => PieceDetailsScreen(pieceId: pieceId));

    case routes.FollowPieceRoute:
      var pieceId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => FollowPieceScreen(pieceId: pieceId));

    case routes.FollowedPieceDetailsRoute:
      var itemId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => FollowedPieceDetailsScreen(itemId: itemId));

    case routes.FollowPieceCongratsRoute:
      return MaterialPageRoute(
          builder: (context) => FollowPieceCongratsScreen());

    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('Nenhuma tela encontrada para ${settings.name}'),
          ),
        ),
      );
  }
}
