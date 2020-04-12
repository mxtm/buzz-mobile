import 'package:flutter/material.dart';
import 'package:buzz/services/log.dart';
import 'package:buzz/services/database.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {

  String videoUrl = "";

  Future<List<VisitorLog>> fetchLog() async {
    var dbHelper = DBHandler();
    Future<List<VisitorLog>> visitors = dbHelper.getLog();
    return visitors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Visitor Log'),
          backgroundColor: Colors.amber[800],
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            videoUrl == ""? Container()
            : Container(
              height: 40.0,
              child: Center(child: Text(videoUrl)),
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchLog(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 4.0,
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(snapshot.data[index].firstName + " " + snapshot.data[index].lastName + " " + snapshot.data[index].time),
                              onTap: () {
                                setState(() {
                                  videoUrl = snapshot.data[index].video;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    );
                  }
                  else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
    );
  }
}
