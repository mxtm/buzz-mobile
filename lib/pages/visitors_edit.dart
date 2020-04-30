//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:buzz/services/database.dart';
//import 'package:buzz/services/visitor.dart';

class VisitorsEdit extends StatefulWidget {
  @override
  _VisitorsEditState createState() => _VisitorsEditState();
}

class _VisitorsEditState extends State<VisitorsEdit> {
  Map data = {};
  String firstName = '';
  String lastName = '';
  String number = '';
  File fileImage;

  //TODO make a class for these functions. Used here and in add
  Future<String> getImageUrl(StorageReference reference) async {
    String url = await reference.getDownloadURL();
    return url;
  }

  Future<String> uploadImage(File image, int id) async {
    String downloadUrl;
    StorageReference reference = FirebaseStorage.instance.ref();
    if (image != null) {
      reference = reference.child("$id");
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

//  File profilePic;

  String path;
  Future<void> getPath() async {
    path = (await getApplicationDocumentsDirectory()).path;
//    profilePic = File('$path/${data['id']}');
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Images/wallpaper.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Edit Visitor'),
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
                if (firstName == '' || firstName == null) {
                  firstName = data['firstName'];
                }
                if (lastName == '' || lastName == null) {
                  lastName = data['lastName'];
                }
                if (number == '' || number == null) {
                  number = data['number'];
                }
                if (fileImage != null) {
                  data['image'] = await uploadImage(fileImage, data['id']);
                }
                Navigator.pop(context, {
                  'firstName': firstName,
                  'lastName': lastName,
                  'number': number,
                  'image': data['image'],
                });
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: getPath(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 175.0,
                    height: 175.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: FileImage(File('$path/${data['id']}')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
//                  labelText: 'First Name',
                      hintText: data['firstName'],
                    ),
                    onChanged: (String str) {
                      setState(() {
                        firstName = str;
                      });
                    },
                  ),
                ),
                SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
//                  labelText: 'Last Name',
                      hintText: data['lastName'],
                    ),
                    onChanged: (String str) {
                      setState(() {
                        lastName = str;
                      });
                    },
                  ),
                ),
                SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
//                  labelText: 'Contact Number',
                      hintText: data['number'],
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
                        child: Text('Camera',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          FocusScope.of(context).unfocus(focusPrevious: true);
                          File f = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            fileImage = f;
//                            profilePic = f;
//                            profilePic = FileImage(File('$path/${data['id']}'));
                          });
                        },
                      ),
                      SizedBox(width: 10.0),
                      RaisedButton(
                        color: Color(0xFF992409),
                        child: Text('Gallery',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          FocusScope.of(context).unfocus(focusPrevious: true);
                          File f = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            fileImage = f;
//                            profilePic = f;
//                            profilePic = FileImage(File('$path/${data['id']}'));
                          });
                        },
                      )
                    ]),
              ],
            );
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          var dbHelper = DBHandler();
//          dbHelper.deleteVisitor(data['id']);
//          Navigator.pop(context, {});
//        },
//        child: Icon(Icons.delete),
//        backgroundColor: Colors.red,
//      ),
          },
        ),
      ),
    );
  }
}
