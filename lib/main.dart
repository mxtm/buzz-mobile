import 'package:flutter/material.dart';
import 'package:buzz/pages/loading.dart';
import 'package:buzz/pages/home.dart';
import 'package:buzz/pages/log_page.dart';
import 'package:buzz/pages/visitors_page.dart';
import 'package:buzz/pages/visitors_add.dart';
import 'package:buzz/pages/visitors_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

// when the app is opened, the loading screen is displayed
// all routes are set up to direct to corresponding pages
void main() => runApp(MaterialApp(
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
    ));

