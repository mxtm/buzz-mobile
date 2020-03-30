import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VisitorsEdit extends StatefulWidget {
  @override
  _VisitorsEditState createState() => _VisitorsEditState();
}

// TODO make sure to show the original name when editing if nothing is present in the text editor box

class _VisitorsEditState extends State<VisitorsEdit> {
  Map data = {};
  String firstName = '';
  String lastName = '';
  File fileImage;

  //TODO make a class for these functions. Used here and in add
  Future<String> getImageUrl(StorageReference reference) async {
    String url = await reference.getDownloadURL();
    return url;
  }

  Future<String> uploadImage(
      File image, String firstName, String lastName) async {
    //TODO figure out way to have many people with the same name
    String downloadUrl;
    StorageReference reference = FirebaseStorage.instance.ref();
    if (image != null) {
      reference = reference.child('$firstName $lastName');
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

  //TODO fix the delete images
//  deleteImage(String image) async {
//    if (image == null) {
//        return;
//    }
//    else {
//      StorageReference reference = await FirebaseStorage.instance.getReferenceFromUrl(image);
//      await reference.delete();
//    }
//  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Visitor'),
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
              //TODO delete old image from firebase
              //await deleteImage(data['image']);
              data['image'] = await uploadImage(fileImage, firstName, lastName);
              Navigator.pop(context, {
                'firstName': firstName,
                'lastName': lastName,
                'image': data['image'],
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
              decoration: InputDecoration(
                hintText: data['firstName'],
              ),
              onChanged: (String str) {
                setState(() {
                  firstName = str;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: data['lastName'],
              ),
              onChanged: (String str) {
                setState(() {
                  lastName = str;
                });
              },
            ),
          ),
          SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            RaisedButton(
              child: Text("Camera"),
              onPressed: () async {
                File f =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                setState(() {
                  fileImage = f;
                });
              },
            ),
            SizedBox(width: 10.0),
            RaisedButton(
              child: Text("Gallery"),
              onPressed: () async {
                File f =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  fileImage = f;
                });
              },
            )
          ])
        ],
      ),
    );
  }
}
