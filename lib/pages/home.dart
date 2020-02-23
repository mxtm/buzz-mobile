import 'package:flutter/material.dart';
import 'package:buzz/services/visitors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Text('BUZZ',
              style: TextStyle(
                fontSize: 50,
                color: Colors.blue,
                letterSpacing: 2.0,
              )
            ),
              SizedBox(height: 20.0),
              FlatButton.icon(
                onPressed: (){
                  // TODO take the user to the camera page TBA
                },
                icon: Icon(
                    Icons.videocam,
                    color: Colors.green,
                    size: 150,
                ),
                label: Text(''),
                color: Colors.grey[300],
              ),
              SizedBox(height: 20.0),
            Text('Visitor',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.blue,
                  letterSpacing: 2.0,
                )
            ),
              FlatButton.icon(
                onPressed: (){
                  // navigates user to the visitor page
                  Navigator.pushNamed(context, '/visitors_page');
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.blueGrey[700],
                  size: 150,
                ),
                label: Text(''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
