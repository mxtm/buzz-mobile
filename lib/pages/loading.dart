import 'package:buzz/services/beemovie.dart';
import 'package:flutter/material.dart';
import 'package:buzz/services/database.dart';

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
    await Future.delayed(Duration(seconds: 2), () {});
    Navigator.pushReplacementNamed(context, '/home');
  }

  void getImages() async {
    var db = new DBHandler();
    await db.storeImages();
  }


  @override
  void initState() {
    // run the original initState
    super.initState();
    getImages();
    setupRaspberryPi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'BUZZ',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.black,
                  ),
                ),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('A 🇱🇧 🇺🇸 🇸🇪 collaboration'),
            ],
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(BeeMovieQuotes().toString(),
                      style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 12.0)),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('- Bee Movie (2007)',
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 12.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
