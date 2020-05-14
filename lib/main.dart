import 'package:flutter/material.dart';
import 'package:buzz/pages/loading.dart';
import 'package:buzz/pages/home.dart';
import 'package:buzz/pages/log_page.dart';
import 'package:buzz/pages/visitors_page.dart';
import 'package:buzz/pages/visitors_add.dart';
import 'package:buzz/pages/visitors_edit.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

// when the app is opened, the loading screen is displayed
// all routes are set up to direct to corresponding pages

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(OKToast(
        child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => BNB(),
        '/log_page': (context) => LogPage(),
        '/visitors_page': (context) => VisitorsPage(),
        '/visitors_add': (context) => VisitorsAdd(),
        '/visitors_edit': (context) => VisitorsEdit(),
      },
      debugShowCheckedModeBanner: false,
    )));
  });
}
