import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buzz/services/database.dart';
import 'package:buzz/services/visitor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VisitorsPage extends StatefulWidget {
  @override
  _VisitorsPageState createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {
  String path;

  Future<List<Visitor>> fetchVisitors() async {
    var dbHelper = DBHandler();
    path = (await getApplicationDocumentsDirectory()).path;
    Future<List<Visitor>> visitors = dbHelper.getCollection();
    return visitors;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Visitors'),
          backgroundColor: Color(0xFFFCB43A),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () async {
                  dynamic result =
                      await Navigator.pushNamed(context, '/visitors_add');
                  var dbHelper = DBHandler();
                  var visitor = Visitor(result['firstName'], result['lastName'],
                      result['number'], result['image']);
                  dbHelper.saveVisitors(visitor);
                  setState(() {});
                }),
          ],
        ),
        body: FutureBuilder(
            future: fetchVisitors(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    // get the number of visitors
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actions: <Widget>[
                          IconSlideAction(
                            caption: 'Call',
                            color: Colors.green,
                            icon: Icons.call,
                            onTap: () {
                              launch("tel:" + snapshot.data[index].number);
                            },
                          ),
                        ],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Deleting visitor'),
                                        content: Text(
                                            'Are you sure you want to delete ' +
                                                snapshot.data[index].firstName +
                                                ' ' +
                                                snapshot.data[index].lastName +
                                                ' from your visitors?'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              var dbHelper = DBHandler();
                                              dbHelper.deleteVisitor(
                                                  snapshot.data[index].id);
                                              Navigator.pop(context, {});
                                              setState(() {});
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              Navigator.pop(context, {});
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 4.0,
                          ),
                          child: Card(
                            // to list different visitors
                            child: File('$path/${snapshot.data[index].id}')
                                    .existsSync()
                                ? ListTile(
                                    onTap: () async {
                                      print('file');
                                      dynamic result =
                                          await Navigator.pushNamed(
                                              context, '/visitors_edit',
                                              arguments: {
                                            'firstName':
                                                snapshot.data[index].firstName,
                                            'lastName':
                                                snapshot.data[index].lastName,
                                            'number':
                                                snapshot.data[index].number,
                                            'image': snapshot.data[index].image,
                                            'id': snapshot.data[index].id,
                                          });
                                      if (result != null) {
                                        var dbHelper = DBHandler();
                                        await dbHelper.editVisitor(
                                            Visitor.withID(
                                                snapshot.data[index].id,
                                                result['firstName'],
                                                result['lastName'],
                                                result['number'],
                                                result['image']));
                                        setState(() {});
                                      }
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: FileImage(File(
                                          '$path/${snapshot.data[index].id}')),
                                    ),
                                    title: Text(
                                      snapshot.data[index].firstName +
                                          ' ' +
                                          snapshot.data[index].lastName,
                                    ),
                                  )
                                : ListTile(
                                    onTap: () async {
                                      print('network');
                                      dynamic result =
                                          await Navigator.pushNamed(
                                              context, '/visitors_edit',
                                              arguments: {
                                            'firstName':
                                                snapshot.data[index].firstName,
                                            'lastName':
                                                snapshot.data[index].lastName,
                                            'number':
                                                snapshot.data[index].number,
                                            'image': snapshot.data[index].image,
                                            'id': snapshot.data[index].id,
                                          });
                                      if (result != null) {
                                        var dbHelper = DBHandler();
                                        await dbHelper.editVisitor(
                                            Visitor.withID(
                                                snapshot.data[index].id,
                                                result['firstName'],
                                                result['lastName'],
                                                result['number'],
                                                result['image']));
                                        setState(() {});
                                      }
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data[index].image),
                                    ),
                                    title: Text(
                                      snapshot.data[index].firstName +
                                          ' ' +
                                          snapshot.data[index].lastName,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
