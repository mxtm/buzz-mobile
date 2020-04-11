import 'package:buzz/services/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBHandler {
  final databaseReference = Firestore.instance;
  List<Visitor> visitors = [];
  static int idCount;

  void saveVisitors(Visitor visitor) async {
    String firstName = visitor.firstName;
    String lastName = visitor.lastName;
    String image = visitor.image;
    int id = idCount;

    await databaseReference.collection("visitors").document("$id")
    .setData({
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
    });
    idCount++;
  }

  editVisitor(Visitor v) async {
    try {
      await databaseReference.collection("visitors").document("${v.id}")
          .updateData({
        'firstName': v.firstName,
        'lastName': v.lastName,
        'image': v.image,
      });
    } catch (e) {
      print(e.toString());
    };
  }

  void deleteVisitor(int id) async {
    try {
      databaseReference.collection("visitors").document("$id").delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Visitor>> getCollection() async {
    String first;
    String last;
    String image;
    String idLocal;
    await databaseReference.collection("visitors")
        .getDocuments().then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((doc) {
            idLocal = doc.documentID;
            first = doc.data['firstName'];
            last = doc.data['lastName'];
            image = doc.data['image'];
            visitors.add(Visitor.withID(int.parse(idLocal),first,last,image));
          });
    }) ;
    idCount = visitors.last.id + 1;
    return visitors;
  }
}
