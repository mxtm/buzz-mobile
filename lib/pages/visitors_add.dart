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
  String number = '';
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

  FocusNode focusNode = FocusNode();
  String hintText = '';

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      }
      setState(() {});
    });
  }
  // hintText: first == '' ? 'First Name' : first

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Add Visitor'),
          backgroundColor: Color(0xFFFCB43A),
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
                  'number': number,
                  'image': image,
                });
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                focusNode: focusNode,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'First Name',
                    hintText: hintText),
                onChanged: (String str) {
                  setState(() {
                    first = str;
                  });
                },
              ),
            ),
            SizedBox(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Last Name',
                    hintText: hintText),
                onChanged: (String str) {
                  setState(() {
                    last = str;
                  });
                },
              ),
            ),
            SizedBox(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Contact Number',
                  hintText: hintText,
                ),
                keyboardType: TextInputType.number,
                onChanged: (String str) {
                  setState(() {
                    number = str;
                  });
                },
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Color(0xFF992409),
                  child: Text('Camera', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    FocusScope.of(context).unfocus(focusPrevious: true);
                    File f =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    setState(() {
                      fileImage = f;
                    });
                  },
                ),
                SizedBox(width: 10.0),
                RaisedButton(
                    color: Color(0xFF992409),
                    child:
                        Text('Gallery', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      FocusScope.of(context).unfocus(focusPrevious: true);
                      File f = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      setState(() {
                        fileImage = f;
                      });
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
