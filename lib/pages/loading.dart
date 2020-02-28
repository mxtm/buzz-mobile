import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  // when launching the app
  // this should connect to the raspberry pi
  // then after connecting it should take the user to the home page
  void setupRaspberryPi() async {
    // connect to the raspberry pi
    // await raspberry pi before going to home page
    await Future.delayed(Duration(seconds: 1), (){});
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    // run the original initState
    super.initState();
    setupRaspberryPi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[800],
      body: Center(
        child: Text('BUZZ',
            style: TextStyle(
                fontSize: 50,
                color: Colors.black,
            ),
        ),
      ),
    );
  }
}
