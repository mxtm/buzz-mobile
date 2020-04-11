import 'package:buzz/services/database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VisitorsAdd extends StatefulWidget {
  @override
  _VisitorsAddState createState() => _VisitorsAddState();
}

class _VisitorsAddState extends State<VisitorsAdd> {
  String first = '';
  String last = '';
  String image = '';
  File fileImage;

  Future<String> getImageUrl(StorageReference reference) async {
    String url = await reference.getDownloadURL();
    return url;
  }

  Future<String> uploadImage(File image, int id) async {
    String downloadUrl;
    StorageReference reference = FirebaseStorage.instance.ref();
    if (image != null) {
      reference = reference.child('$id');
      StorageUploadTask uploadTask = reference.putFile(image);
      await uploadTask.onComplete;
      await getImageUrl(reference).then((url) {
        downloadUrl = url;
      });
    } else {
      reference = reference.child('Image/avatar.jpg');
      await getImageUrl(reference).then((url) {
        downloadUrl = url;
      });
    }
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Visitor'),
        backgroundColor: Colors.amber[800],
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              image = await uploadImage(fileImage, DBHandler.idCount);
              Navigator.pop(context, {
                'firstName': first,
                'lastName': last,
                'image': image,
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
            child: TextField(
              decoration: InputDecoration(hintText: first ==''?'First Name':first),
              onChanged: (String str) {
                setState(() {
                  first = str;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
            child: TextField(
              decoration: InputDecoration(hintText: last == ''?'Last Name':last),
              onChanged: (String str) {
                setState(() {
                  last = str;
                });
              },
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Camera"),
                onPressed: () async {
                  FocusScope.of(context).unfocus(focusPrevious: true);
                  File f = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    fileImage = f;
                  });
                },
              ),
              SizedBox(width: 10.0),
              RaisedButton(
                  child: Text("Gallery"),
                  onPressed: () async {
                    FocusScope.of(context).unfocus(focusPrevious: true);
                    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      fileImage = f;
                    });
                  })
            ],
          ),
        ],
      ),
    );
  }
}
