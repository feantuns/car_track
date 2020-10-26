import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: new Column(
          children: <Widget>[
            Container(
              color: Colors.grey[350],
              height: 300,
              child: Padding(
                padding: new EdgeInsets.fromLTRB(30, 50, 0, 100),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Olá',
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Vamos começar com o cadastro de um novo veículo',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0.0, -70.0),
              child: Card(
                elevation: 6,
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    splashColor: Colors.grey.withAlpha(30),
                    onTap: () {
                      Navigator.pushNamed(context, '/new-car-1');
                    },
                    child: Container(
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage('assets/half_car.png'),
                              fit: BoxFit.none,
                              alignment: Alignment(1.0, -0.5)),
                        ),
                        padding: EdgeInsets.all(12),
                        height: 170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Novo veículo',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
