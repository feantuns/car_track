import 'package:flutter/material.dart';

class TitleCarousel extends StatelessWidget {
  TitleCarousel(
      {Key key,
      this.title,
      this.items,
      this.onTap,
      this.imagePath,
      this.scaleImg = 1.3})
      : super(key: key);

  final String title;
  final List items;
  final Function onTap;
  final String imagePath;
  final double scaleImg;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54)),
            ),
            SizedBox(height: 16),
            Container(
                height: 150,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: items.map((document) {
                      return Container(
                        width: 180,
                        margin: EdgeInsets.only(bottom: 8),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.only(right: 16.0),
                          child: InkWell(
                            splashColor: Colors.grey.withAlpha(30),
                            onTap: () {
                              onTap(
                                document.id,
                              );
                            },
                            child: Container(
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new AssetImage(imagePath),
                                      fit: BoxFit.none,
                                      scale: scaleImg,
                                      alignment: Alignment(1.0, -0.5)),
                                ),
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      document['nome'],
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      );
                    }).toList()))
          ]),
    );
  }
}
