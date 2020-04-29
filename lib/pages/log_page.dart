import 'package:flutter/material.dart';
import 'package:buzz/services/log.dart';
import 'package:buzz/services/database.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String videoUrl = "";
  int vidIndex = -1;
  GlobalKey imageKey;
  VideoPlayerController _controller;
  final _scrollController = ScrollController();
  String path = "";

  Future<String> getPath() async {
    return (await getTemporaryDirectory()).path;
}

  void _moveToVideo(int index) {
    _scrollController.animateTo(80.0 * index,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void _initNetworkController(String link) {
    _controller = VideoPlayerController.network(link)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  void _initFileController(String path) {
    _controller = VideoPlayerController.file(File(path))
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        }) ;
  }

  Future<void> _startVideoPlayer(String link, bool networkSource) async {
    if (_controller == null && networkSource) {
      _initNetworkController(link);
    } else if (_controller == null && !networkSource){
      _initFileController(link);
    } else {
      final oldController = _controller;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController.dispose();
        if (networkSource)
          {
            _initNetworkController(link);
          }
        else
          {
            _initFileController(link);
          }
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
                      controller: _scrollController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actions: <Widget>[
                            new IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                var dbHelper = DBHandler();
                                await dbHelper.deleteVideo(snapshot.data[index].time,snapshot.data[index].video);
                                setState(() {});
                              },
                            ),
                          ],
                          child: Padding(
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
                                          var dbHelper = DBHandler();
                                          String setPath = (await getPath()) + '/${snapshot.data[index].time.replaceAll('/','').replaceAll(':','').replaceAll(' ','')}';
                                          if (!File(setPath).existsSync())
                                            {
                                              dbHelper.storeVideos(snapshot.data[index].name,snapshot.data[index].time,snapshot.data[index].video);
                                            }
                                          setState(() {
                                            videoUrl = snapshot.data[index].video;
                                            vidIndex = index;
                                            _moveToVideo(index);
                                            path = setPath;
                                            if (!File(path).existsSync())
                                              {
                                                _startVideoPlayer(videoUrl,true);
                                              }
                                            else
                                              {
                                                _startVideoPlayer(path,false);
                                              }
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
                                    )),
                        );
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
