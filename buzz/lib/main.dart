import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:starflut/starflut.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.amber),
      home: Scaffold(
        appBar: AppBar(
          title: Text('BUZZ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          centerTitle: true,
        ),
        body: Center(
          child: RaisedButton(
            onPressed: (){
              // do the star shit here
            },
            child: Icon(
              Icons.videocam,
              color: Colors.green[500],
              size: 250,
            ),
          ),
        ),
      ),
    );
  }
}