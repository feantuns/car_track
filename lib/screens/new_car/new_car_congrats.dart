import 'package:car_track/constants/route_paths.dart' as routes;
import 'package:car_track/locator.dart';
import 'package:car_track/services/navigation_service.dart';
import 'package:flutter/material.dart';

class NewCarCongratsScreen extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
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
                  'Seu carro foi cadastrado com sucesso',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54),
                ),
                SizedBox(height: 40),
                Center(child: Image(image: AssetImage("assets/congrats.png"))),
                SizedBox(height: 40),
                Text(
                  'Veja seus carros na tela inicial',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54),
                ),
                SizedBox(height: 30),
                Center(
                  child: RaisedButton(
                      onPressed: () =>
                          _navigationService.navigateTo(routes.HomeRoute),
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
  }
}
