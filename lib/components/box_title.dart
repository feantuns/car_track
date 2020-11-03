import 'package:flutter/material.dart';

class BoxTitle extends StatelessWidget {
  BoxTitle(
      {Key key,
      this.title,
      this.subtitle,
      this.titleSize = 26,
      this.subtitleSize = 26})
      : super(key: key);

  final String title;
  final String subtitle;
  final double titleSize;
  final double subtitleSize;

  @override
  Widget build(BuildContext context) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700])),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(subtitle,
                style: TextStyle(
                    fontSize: subtitleSize,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[700])),
          ),
        ]);
  }
}
