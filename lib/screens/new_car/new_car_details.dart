import 'package:car_track/models/car.dart';
import 'package:car_track/actions/actions.dart';
import 'package:car_track/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:car_track/models/app_state.dart';

@immutable
class NewCarDetailsViewModel {
  final Function updateNewCar;
  final Car novoCarro;
  final bool isLoading;
  final bool createdNewCar;

  NewCarDetailsViewModel(
      {this.updateNewCar, this.novoCarro, this.isLoading, this.createdNewCar});
}

class NewCarDetailsScreen extends StatefulWidget {
  _NewCarDetailsState createState() => _NewCarDetailsState();
}

class _NewCarDetailsState extends State<NewCarDetailsScreen> {
  bool checked = true;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, NewCarDetailsViewModel>(
        builder: (context, NewCarDetailsViewModel viewModel) {
      if (viewModel.createdNewCar != null && viewModel.createdNewCar) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }

      return new Scaffold(
          body: Builder(
        builder: (context) => Container(
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                    height: 280,
                    color: Colors.grey[350],
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Image(
                            image: AssetImage("assets/half_car_big.png")))),
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
                Transform.translate(
                  offset: const Offset(0.0, 40.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(viewModel.novoCarro.nome,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700])),
                        SizedBox(height: 8),
                        Text('Marca',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700])),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(viewModel.novoCarro.marca,
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[700])),
                        ),
                        SizedBox(height: 24),
                        Text('Modelo',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700])),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(viewModel.novoCarro.modelo,
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[700])),
                        ),
                        SizedBox(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.all(0),
                          dense: true,
                          title: Text("Esse é o carro que mais uso",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey[700])),
                          value: checked,
                          onChanged: (newValue) {
                            setState(() {
                              checked = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 32,
                  right: 16,
                  child: RaisedButton(
                    onPressed: () {
                      viewModel.updateNewCar(new Car(
                          maisUsado: checked,
                          marca: viewModel.novoCarro.marca,
                          modelo: viewModel.novoCarro.modelo,
                          nome: viewModel.novoCarro.nome));
                    },
                    color: Colors.deepPurpleAccent[700],
                    padding: EdgeInsets.fromLTRB(13, 12, 13, 12),
                    child: Row(
                      children: <Widget>[
                        Text('É ISSO',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 8),
                        (viewModel.isLoading != null && viewModel.isLoading)
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
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
      return new NewCarDetailsViewModel(
        updateNewCar: (Car novoCarro) {
          store.dispatch(new CreateNewCarAction(novoCarro));
        },
        novoCarro: store.state.novoCarro,
        isLoading: store.state.isLoadingNewCar,
        createdNewCar: store.state.createdNewCar,
      );
    });
  }
}
