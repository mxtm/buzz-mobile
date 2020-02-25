import 'package:flutter/material.dart';
import 'package:buzz/pages/loading.dart';
import 'package:buzz/pages/home.dart';
import 'package:buzz/pages/visitors_page.dart';
import 'package:buzz/pages/visitors_add.dart';
import 'package:buzz/pages/visitors_edit.dart';
import 'package:buzz/pages/recieve_call.dart';
import 'package:buzz/pages/check_camera.dart';
//import 'package:buzz/services/visitors.dart';

// when the app is opened, the loading screen is displayed
// all routes are set up to direct to corresponding pages
void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
    '/visitors_page': (context) => VisitorsPage(),
    '/visitors_add': (context) => VisitorsAdd(),
    '/visitors_edit': (context) => VisitorsEdit(),
    '/recieve_call': (context) => RecieveCall(),
    '/check_camera': (context) => CheckCamera(),
  },
  debugShowCheckedModeBanner: false
));