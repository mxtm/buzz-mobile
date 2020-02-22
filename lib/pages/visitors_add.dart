import 'package:flutter/material.dart';

class VisitorsAdd extends StatefulWidget {
  @override
  _VisitorsAddState createState() => _VisitorsAddState();
}

class _VisitorsAddState extends State<VisitorsAdd> {

  String first = '';
  String last = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Visitor'),
        backgroundColor: Colors.amber[800],
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('Done',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: (){
              Navigator.pop(context, {
                'firstName': first,
                'lastName': last,
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
                hintText: 'First Name'
              ),
              onChanged: (String str){
                setState(() {
                  first = str;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Last Name'
              ),
              onChanged: (String str){
                setState(() {
                  last = str;
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
