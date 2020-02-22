import 'package:flutter/material.dart';
import 'package:buzz_cmps253/services/visitors.dart';

class VisitorsPage extends StatefulWidget {
  @override
  _VisitorsPageState createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {

  List<Visitors> visitors = [
    Visitors(firstName: 'Sari', lastName: 'Nuwayhid', image: 'Untitled.png'),
    Visitors(firstName: 'Zacharia', lastName: 'Bayram', image: 'Untitled.png'),
    Visitors(firstName: 'Maxwell', lastName: 'Mahoney', image: 'Untitled.png'),
    Visitors(firstName: 'Bassem', lastName: 'Bahsoun', image: 'Untitled.png'),
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
                  image: 'Untitled.png',
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
