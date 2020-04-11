//import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';

class Visitor {
//  static int id;
  int id;
  String firstName;
  String lastName;
  String image;

  Visitor(this.firstName, this.lastName, this.image);

  Visitor.withID(this.id, this.firstName, this.lastName, this.image);

  String toString()
  {
    return (this.firstName + " "+ this.lastName + " "+ this.image);
  }

}
