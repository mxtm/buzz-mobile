import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:buzz/pages/log_page.dart';
import 'package:buzz/pages/visitors_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

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
                color: Colors.amber[800],
                letterSpacing: 2.0,
              )
            ),
              SizedBox(height: 20.0),
              FlatButton.icon(
                onPressed: (){
                  // takes the user to the camera page TBA
                  Navigator.pushNamed(context, '/check_camera');
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
            Text('Visitors',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.amber[800],
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

// created a Bottom Navigation Bar widget
// starts on homepage, Loading points to this
// first page on the BNB is the home page
// this is padded onto the home page
class BNB extends StatefulWidget {
  @override
  _BNBState createState() => _BNBState();
}

class _BNBState extends State<BNB> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    LogPage(),
    Home(),
    VisitorsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Visitor Log'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Visitors'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
