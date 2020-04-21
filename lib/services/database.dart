import 'package:buzz/services/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:buzz/services/log.dart';

class DBHandler {
  final databaseReference = Firestore.instance;
  List<Visitor> visitors = [];
  List<VisitorLog> vLog = [];
  static int idCount;

  void saveVisitors(Visitor visitor) async {
    String firstName = visitor.firstName;
    String lastName = visitor.lastName;
    String number = visitor.number;
    String image = visitor.image;
    int id = idCount;

    await databaseReference.collection("visitors").document("$id").setData({
      'firstName': firstName,
      'lastName': lastName,
      'number': number,
      'image': image,
    });
    idCount++;
  }

  editVisitor(Visitor v) async {
    try {
      await databaseReference
          .collection("visitors")
          .document("${v.id}")
          .updateData({
        'firstName': v.firstName,
        'lastName': v.lastName,
        'number': v.number,
        'image': v.image,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteVisitor(int id) async {
    try {
      databaseReference.collection("visitors").document("$id").delete();
    } catch (e) {
      print(e.toString());
    }
    StorageReference reference = FirebaseStorage.instance.ref().child("$id");
    reference.delete();
  }

  Future<List<Visitor>> getCollection() async {
    int max = -1;
    String first;
    String last;
    String number;
    String image;
    String idLocal;
    await databaseReference
        .collection("visitors")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        idLocal = doc.documentID;
        if (int.parse(idLocal) > max) {
          max = int.parse(idLocal);
        }
        first = doc.data['firstName'];
        last = doc.data['lastName'];
        number = doc.data['number'];
        image = doc.data['image'];
        visitors.add(
            Visitor.withID(int.parse(idLocal), first, last, number, image));
      });
    });
    idCount = max + 1;
    return visitors;
  }

  Future<List<VisitorLog>> getLog() async {
    String name;
    String time;
    String video;
    await databaseReference
        .collection("visitors_log")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        name = doc.data['visitors'];
        time = doc.data['timestamp'];
        video = doc.data['video'];
        vLog.add(
          VisitorLog(name,time,video)
        );
      });
    });
    return vLog;
  }
}
