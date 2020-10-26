import 'package:car_track/models/car.dart';
import 'package:car_track/actions/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:car_track/models/app_state.dart';

@immutable
class NewCar2ViewModel {
  final Function updateNewCar;
  final Car novoCarro;

  NewCar2ViewModel({this.updateNewCar, this.novoCarro});
}

class NewCar2Screen extends StatelessWidget {
  String value = "";

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, NewCar2ViewModel>(
        builder: (context, NewCar2ViewModel viewModel) {
      return new Scaffold(
          body: Builder(
        builder: (context) => Container(
            color: Colors.white,
            child: Stack(
              children: [
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(16, 80, 0, 16),
                    child: Text('Qual é o modelo do seu carro?',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]))),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 80),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextFormField(
                        onChanged: (text) {
                          value = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Modelo',
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 32,
                  right: 16,
                  child: RaisedButton(
                    onPressed: () {
                      if (value != '') {
                        viewModel.updateNewCar(new Car(
                            maisUsado: null,
                            marca: viewModel.novoCarro.marca,
                            modelo: value,
                            nome: null));
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
                        Icon(
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
      return new NewCar2ViewModel(
          updateNewCar: (Car novoCarro) {
            store.dispatch(new UpdateNewCarAction(novoCarro));
            Navigator.pushNamed(context, '/new-car-3');
          },
          novoCarro: store.state.novoCarro);
    });
  }
}
