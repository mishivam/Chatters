import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final double circleRadius = 100.0;
  final double circleBorderWidth = 8.0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            // width:MediaQuery.of(context).size.width ,
            // height: MediaQuery.of(context).size.height/1.5,
            constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height / 1.5,
                width: double.infinity),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/facebook.png',
                  ),
                  fit: BoxFit.cover),
            )),
            
        Column(
      // alignment: Alignment.topCenter,
      children: <Widget>[
          
          Container(
            width: circleRadius,
            height: circleRadius,
            decoration:
                ShapeDecoration(shape: CircleBorder(), color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(circleBorderWidth),
              child: DecoratedBox(
                decoration: ShapeDecoration(
          shape: CircleBorder(),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg',
              ))),
              ),
            ),
          )
      ],
    )
      ],
    );
  }
}
