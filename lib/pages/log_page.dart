import 'package:flutter/material.dart';
import 'package:buzz/services/log.dart';
import 'package:buzz/services/database.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/vlc_player_controller.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {

  String videoUrl = "";
  int vidIndex = -1;
  VlcPlayerController videoViewController;
  GlobalKey imageKey;

  @override
  void initState() {
    imageKey = new GlobalKey();
    videoViewController = new VlcPlayerController();
    super.initState();
  }

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
                          child: index != vidIndex? Card(
                            child: ListTile(
                              title: Text(snapshot.data[index].firstName + " " + snapshot.data[index].lastName + " " + snapshot.data[index].time),
                              onTap: () {
                                setState(() {
                                  videoUrl = snapshot.data[index].video;
                                  vidIndex = index;
                                });
                              },
                            ),
                          )
                          : Column(
                            children: <Widget>[
                              Card(
                                child: ListTile(
                                  title: Text(snapshot.data[index].firstName + " " + snapshot.data[index].lastName + " " + snapshot.data[index].time),
                                  onTap: () {
                                    setState(() {
                                      videoUrl = snapshot.data[index].video;
                                      vidIndex = -1;
                                    });
                                  },
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 4/3,
                                child: VlcPlayer(
                                  url: "$videoUrl",
                                  controller: videoViewController,
                                  placeholder: Container(
                                    height: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[CircularProgressIndicator()],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
