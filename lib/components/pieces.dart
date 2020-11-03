import 'package:car_track/components/title_carousel.dart';
import 'package:car_track/screens/piece_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Pieces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference pieces =
        FirebaseFirestore.instance.collection('pieces');

    return StreamBuilder<QuerySnapshot>(
        stream: pieces.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data.docs;

          return Scaffold(
              body: Container(
            child: data.length > 0
                ? new TitleCarousel(
                    scaleImg: 2,
                    items: snapshot.data.docs,
                    title: 'Peças do veículo',
                    imagePath: 'assets/piece.png',
                    onTap: (id) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PieceDetailsScreen(
                                    pieceId: id,
                                  )),
                        ))
                : Text(
                    'Nenhuma peça encontrada :(',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54),
                  ),
          ));
        });
  }
}
