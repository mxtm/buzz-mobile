import 'package:flutter/material.dart';
import 'package:buzz/services/visitors.dart';
import 'package:buzz/services/logger.dart';

class VisitorsPage extends StatefulWidget {
  @override
  _VisitorsPageState createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {

  List<Visitors> visitors = [Visitors(firstName: 'f', lastName: 'l', image: 'i')];

  getVisitors() async {
    Logger l = new Logger();
    visitors = await l.setup(visitors);
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
              dynamic result = await Navigator.pushNamed(context, '/visitors_add');
              setState(() {
                Visitors v = new Visitors(
                  firstName: result['firstName'],
                  lastName: result['lastName'],
                  image: result['image'],
                );
                visitors.add(v);
              });
            }
          ),
        ],
      ),
      body: FutureBuilder(
        future: getVisitors(),
        builder: (BuildContext context, snapshot) {
          return ListView.builder(
            // get the number of visitors
            itemCount: visitors.length,
            itemBuilder: (context, index) {
              return index == 0? RaisedButton(
                child: Text('Kill Switch'),
                onPressed: () async {
                  Logger l = new Logger();
                  await l.delete(visitors);
                  setState(() {

                  });
                },
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 4.0,
                ),
                child: Card(
                  // to list different visitors
                  child: ListTile(
                    onTap: () async {
                      dynamic result = await Navigator.pushNamed(context, '/visitors_edit', arguments: {
                        // TODO only send index once database is implemented
                        'firstName': visitors[index].firstName,
                        'lastName': visitors[index].lastName,
                        'image': visitors[index].image,
                        'index': index,
                      }
                      );
                      setState(() {
                        visitors[index].firstName = result['firstName'];
                        visitors[index].lastName = result['lastName'];
                        // TODO add image thing
                      });
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          visitors[index].image
                      ),
                    ),
                    title: Text(
                      visitors[index].firstName + ' ' + visitors[index].lastName,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
