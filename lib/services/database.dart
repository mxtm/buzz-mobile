import 'package:buzz/services/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:buzz/services/log.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
    await storeImages();
  }

  editVisitor(Visitor v) async {
    String path = (await getApplicationDocumentsDirectory()).path;
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
    await File('$path/${v.id}').delete();
    await storeImages();
  }

  void deleteVisitor(int id) async {
    String path = (await getApplicationDocumentsDirectory()).path;
    await File('$path/$id').delete();
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

  storeImages() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    List<Visitor> v = await getCollection();
    for (int i = 0; i < v.length; i++) {
      bool check = await File('$path/${v[i].id}').exists();
      if (!check) {
        HttpClient client = new HttpClient();
        var request = await client.getUrl(Uri.parse(v[i].image));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        await (new File('$path/${v[i].id}')).writeAsBytes(bytes);
        print('done${v[i].id}');
      }
    }
  }

  storeVideos(String name, String time, String video) async {
    String path = (await getTemporaryDirectory()).path;
    String name =
        time.replaceAll('/', '').replaceAll(':', '').replaceAll(' ', '');
    bool check = await File('$path/$name').exists();
    if (!check) {
      File file = new File('$path/$name');
      HttpClient client = new HttpClient();
      var request = await client.getUrl(Uri.parse(video));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
    }
  }

  deleteVideo(String time, String video) async {
    String path = (await getTemporaryDirectory()).path;
    String name =
        time.replaceAll('/', '').replaceAll(':', '').replaceAll(' ', '');
    String docName = "b'" +
        time.replaceAll('/', '-').replaceAll(':', '-').replaceAll(' ', '_') +
        "'";
    String vidName = video.substring(video.lastIndexOf("/") + 1);
    try {
      databaseReference.collection("visitors_log").document(docName).delete();
    } catch (e) {
      print(e.toString());
    }
    StorageReference reference = FirebaseStorage.instance.ref().child(vidName);
    reference.delete();
    await File('$path/$name').delete();
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
        vLog.add(VisitorLog(name, time, video));
      });
    });
    vLog = vLog.reversed.toList();
    return vLog;
  }
}
