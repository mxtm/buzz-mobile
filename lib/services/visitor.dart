//import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';

class Visitor {
//  static int id;
  int id;
  String firstName;
  String lastName;
  String image;

  Visitor(this.firstName, this.lastName, this.image);
//  {
//    this.firstName = firstName;
//    this.lastName = lastName;
//    this.image = image;
//  }

  Visitor.withID(this.id, this.firstName, this.lastName, this.image);
//  {
//    this.id = id;
//    this.firstName = firstName;
//    this.lastName = lastName;
//    this.image = image;
//  }

//  Map<String, dynamic> toMap() => {
//    "id": id,
//    "firstName": firstName,
//    "lastName": lastName,
//    "image:": image,
//  };
}
