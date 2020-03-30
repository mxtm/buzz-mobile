import 'package:flutter/material.dart';

class VisitorsEdit extends StatefulWidget {
  @override
  _VisitorsEditState createState() => _VisitorsEditState();
}

// TODO make sure to show the original name when editing if nothing is present in the text editor box

class _VisitorsEditState extends State<VisitorsEdit> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Visitor'),
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
            onPressed: () {
              Navigator.pop(context, {
                'firstName': data['firstName'],
                'lastName': data['lastName'],
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
              decoration: InputDecoration(
                hintText: data['firstName'],
              ),
              onChanged: (String str) {
                setState(() {
                  data['firstName'] = str;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: data['lastName'],
              ),
              onChanged: (String str) {
                setState(() {
                  data['lastName'] = str;
                });
              },
            ),
          ),
          // TODO give user a way to select an image
        ],
      ),
    );
  }
}
