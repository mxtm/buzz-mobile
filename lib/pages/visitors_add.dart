import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:buzz/services/visitors.dart';

class VisitorsAdd extends StatefulWidget {
  @override
  _VisitorsAddState createState() => _VisitorsAddState();
}

class _VisitorsAddState extends State<VisitorsAdd> {
  String first = '';
  String last = '';
  String image = '';
  File fileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Visitor'),
        backgroundColor: Colors.amber[800],
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              Visitors v = new Visitors();
              image = await v.uploadImage(fileImage, first, last);
              Navigator.pop(context, {
                'firstName': first,
                'lastName': last,
                'image': image,
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'First Name'),
              onChanged: (String str) {
                setState(() {
                  first = str;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Last Name'),
              onChanged: (String str) {
                setState(() {
                  last = str;
                });
              },
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Camera"),
                onPressed: () async {
                  File f =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    fileImage = f;
                  });
                },
              ),
              SizedBox(width: 10.0),
              RaisedButton(
                child: Text("Gallery"),
                onPressed: () {
                  //TODO add gallery implementation
                },
              )
            ],
          ),
          // TODO give user a way to select an image
        ],
      ),
    );
  }
}
