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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Visitors'),
        backgroundColor: Colors.amber[800],
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
                        new IconSlideAction(
                          caption: 'Call',
                          color: Colors.green,
                          icon: Icons.call,
                          onTap: () {
                            launch("tel:" + snapshot.data[index].number);
                          },
                        ),
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
                                    dynamic result = await Navigator.pushNamed(
                                        context, '/visitors_edit',
                                        arguments: {
                                          'firstName':
                                              snapshot.data[index].firstName,
                                          'lastName':
                                              snapshot.data[index].lastName,
                                          'number': snapshot.data[index].number,
                                          'image': snapshot.data[index].image,
                                          'id': snapshot.data[index].id,
                                        });
                                    var dbHelper = DBHandler();
                                    await dbHelper.editVisitor(Visitor.withID(
                                        snapshot.data[index].id,
                                        result['firstName'],
                                        result['lastName'],
                                        result['number'],
                                        result['image']));
                                    setState(() {});
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
                                    dynamic result = await Navigator.pushNamed(
                                        context, '/visitors_edit',
                                        arguments: {
                                          'firstName':
                                              snapshot.data[index].firstName,
                                          'lastName':
                                              snapshot.data[index].lastName,
                                          'number': snapshot.data[index].number,
                                          'image': snapshot.data[index].image,
                                          'id': snapshot.data[index].id,
                                        });
                                    var dbHelper = DBHandler();
                                    await dbHelper.editVisitor(Visitor.withID(
                                        snapshot.data[index].id,
                                        result['firstName'],
                                        result['lastName'],
                                        result['number'],
                                        result['image']));
                                    setState(() {});
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
    );
  }
}
