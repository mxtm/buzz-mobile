import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

//class CheckCamera extends StatefulWidget {
//  @override
//  _CheckCameraState createState() => _CheckCameraState();
//}
//
//class _CheckCameraState extends State<CheckCamera> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Livestream'),
//        backgroundColor: Colors.amber[800],
//        centerTitle: true,
//      ),
//      body: Mjpeg(
//        stream: 'https://fingerless-llama-8940.dataplicity.io/stream.mjpg',
//        fit: BoxFit.cover,
//      ),
//    );
//  }
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: CheckCamera(),
    );
  }
}

class CheckCamera extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isRunning = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Camera'),
        backgroundColor: Colors.amber[800],
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Mjpeg(
                isLive: isRunning.value,
                stream:
                    'https://fingerless-llama-8940.dataplicity.io/stream.mjpg',
              ),
            ),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  isRunning.value = !isRunning.value;
                },
                child: Text('Toggle'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
