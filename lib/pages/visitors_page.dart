import 'package:flutter/material.dart';
import 'package:buzz/services/visitors.dart';

class VisitorsPage extends StatefulWidget {
  @override
  _VisitorsPageState createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {

  List<Visitors> visitors = [
    Visitors(firstName: 'Sari', lastName: 'Nuwayhid', image: 'Trump.jpg'),
    Visitors(firstName: 'Zacharia', lastName: 'Bayram', image: 'Trump.jpg'),
    Visitors(firstName: 'Maxwell', lastName: 'Tamer-Mahoney', image: 'Trump.jpg'),
    Visitors(firstName: 'Bassem', lastName: 'Bahsoun', image: 'Trump.jpg'),
  ];

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
              // TODO send list as an argument + make async function
              dynamic result = await Navigator.pushNamed(context, '/visitors_add');
              setState(() {
                Visitors v = new Visitors(
                  firstName: result['firstName'],
                  lastName: result['lastName'],
                  // TODO add image option
                  image: 'Trump.jpg',
                );
                visitors.add(v);
                //TODO make this shit scrollable
              });
            }
          ),
        ],
      ),
      body: ListView.builder(
        // get the number of visitors
        itemCount: visitors.length,
        itemBuilder: (context, index) {
          return Padding(
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
                  backgroundImage: AssetImage(
                    'Images/${visitors[index].image}'
                  ),
                ),
                title: Text(
                  visitors[index].firstName + ' ' + visitors[index].lastName,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
