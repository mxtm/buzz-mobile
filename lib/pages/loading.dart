import 'package:buzz/services/beemovie.dart';
import 'package:flutter/material.dart';
import 'package:buzz/services/database.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  wait() async {
    var dbHelper = DBHandler();
    await dbHelper.storeImages();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    // run the original initState
    wait();
    super.initState();
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
