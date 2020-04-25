import 'package:flutter/material.dart';
import 'package:buzz/services/log.dart';
import 'package:buzz/services/database.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class LogPage extends StatefulWidget {
  LogPage({Key key}) : super(key: key);
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage>{

  String videoUrl = "";
  int vidIndex = -1;
  GlobalKey imageKey;
  VideoPlayerController _controller;

  void _initController(String link) {
    _controller = VideoPlayerController.network(link)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  Future<void> _startVideoPlayer(String link) async {
    if (_controller == null) {
      _initController(link);
    } else {
      final oldController = _controller;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController.dispose();
        _initController(link);
      });
      setState(() {
        _controller = null;
      });
    }
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
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 4.0,
                            ),
                            child: index != vidIndex
                                ? Card(
                                    child: ListTile(
                                      title: Text(snapshot.data[index].name),
                                      subtitle: Text(snapshot.data[index].time),
                                      onTap: () async {
                                        //var dbHelper = DBHandler();
                                        //await dbHelper.storeVideos(snapshot.data[index].name,snapshot.data[index].time,snapshot.data[index].video);
                                        setState(() {
                                          videoUrl = snapshot.data[index].video;
                                          vidIndex = index;
                                          _startVideoPlayer(videoUrl);
                                        });
                                      },
                                    ),
                                  )
                                : Column(
                                    children: <Widget>[
                                      Card(
                                        child: ListTile(
                                          title:
                                              Text(snapshot.data[index].name),
                                          subtitle:
                                              Text(snapshot.data[index].time),
                                          onTap: () {
                                            setState(() {
                                              videoUrl =
                                                  snapshot.data[index].video;
                                              vidIndex = -1;
                                            });
                                          },
                                        ),
                                      ),
                                      AspectRatio(
                                        aspectRatio: 4 / 3,
                                        child: (_controller != null
                                            ? VideoPlayer(_controller)
                                            : Container(
                                                height: 200,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    CircularProgressIndicator()
                                                  ],
                                                ),
                                              )),
                                      ),
                                    ],
                                  ));
                      });
                } else {
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
