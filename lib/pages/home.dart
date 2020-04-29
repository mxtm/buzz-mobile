import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:buzz/pages/log_page.dart';
import 'package:buzz/pages/visitors_page.dart';
import 'package:buzz/config.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/vlc_player_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  VlcPlayerController videoViewController;
  GlobalKey imageKey;

  void setupNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        // onDidReceiveLocalNotification: onDidReceiveLocalNotification
        );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings /*, onSelectNotification: selectNotification*/);

    var androidNotificationChannel = AndroidNotificationChannel(
      'door',
      'Door Notifications',
      'Notifications of someone at your door.',
      importance: Importance.Max,
      sound: RawResourceAndroidNotificationSound('doorbell'),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

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

    _firebaseMessaging.subscribeToTopic("global");
  }

  @override
  void initState() {
    imageKey = new GlobalKey();
    videoViewController = new VlcPlayerController();
    super.initState();
    setupNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 4 / 3,
            child: VlcPlayer(
              url: configuration.videoURL,
              controller: videoViewController,
              placeholder: Container(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[CircularProgressIndicator()],
                ),
              ),
              defaultHeight: null,
              defaultWidth: null,
            ),
          ),
        ],
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
//  List<Widget> children = [
//    LogPage(),
//    Home(),
//    VisitorsPage(),
//  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      body: IndexedStack(
//        index: _currentIndex,
//        children: children,
//      ),
//      body: children[_currentIndex],
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: _currentIndex != 0,
            child: new TickerMode(
              enabled: _currentIndex == 0,
              child: LogPage(),
            ),
          ),
          new Offstage(
            offstage: _currentIndex != 1,
            child: new TickerMode(
              enabled: _currentIndex == 1,
              child: Home(),
            ),
          ),
          new Offstage(
            offstage: _currentIndex != 2,
            child: new TickerMode(
              enabled: _currentIndex == 2,
              child: VisitorsPage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFFCB43A),
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
