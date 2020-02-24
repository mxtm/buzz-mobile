import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class CheckCamera extends StatefulWidget {
  @override
  _CheckCameraState createState() => _CheckCameraState();
}

class _CheckCameraState extends State<CheckCamera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livestream'),
        backgroundColor: Colors.amber[800],
        centerTitle: true,
      ),
      body: Mjpeg(
        stream: 'https://fingerless-llama-8940.dataplicity.io/stream.mjpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
