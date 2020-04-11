import 'package:flutter/material.dart';
import 'package:buzz/services/database.dart';
import 'package:buzz/services/visitor.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitorsPage extends StatefulWidget {
  @override
  _VisitorsPageState createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {

  Future<List<Visitor>> fetchVisitors() async {
    var dbHelper = DBHandler();
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
                setState(() {
                  var dbHelper = DBHandler();
                  var visitor = Visitor(
                      result['firstName'], result['lastName'],result['number'], result['image']);
                  dbHelper.saveVisitors(visitor);
                });
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
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.green),
                      onDismissed: (direction) {
//                        var dbHelper = DBHandler();
//                        dbHelper.deleteVisitor(snapshot.data[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 4.0,
                        ),
                        child: Card(
                          // to list different visitors
                          child: ListTile(
                            onTap: () async {
                              dynamic result = await Navigator.pushNamed(
                                  context, '/visitors_edit',
                                  arguments: {
                                    'firstName': snapshot.data[index].firstName,
                                    'lastName': snapshot.data[index].lastName,
                                    'number': snapshot.data[index].number,
                                    'image': snapshot.data[index].image,
                                    'id' :snapshot.data[index].id,
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
                              backgroundImage:
                                  NetworkImage(snapshot.data[index].image),
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
