import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'logger.dart';

class Visitors {
  String firstName;
  String lastName;
  String image;

  Visitors ({this.firstName, this.lastName, this.image});

  Future<String> getImageUrl(StorageReference reference) async{
    String url = await reference.getDownloadURL();
    return url;
  }

  @override
  String toString(){
    return '$firstName$lastName$image';
  }

  Future<String> uploadImage(File image, String first, String last) async {
    //TODO figure out way to have many people with the same name
    String downloadUrl;
    StorageReference reference = FirebaseStorage.instance.ref();
    if (image != null) {
      reference = reference.child('$first $last');
      StorageUploadTask uploadTask = reference.putFile(image);
      await uploadTask.onComplete;
      await getImageUrl(reference).then((url) {downloadUrl = url;});
    }
    else{
      reference = reference.child('Image/avatar.jpg');
      await getImageUrl(reference).then((url) {downloadUrl = url;});
    }
    Logger l = new Logger();
    await l.write(first, last, downloadUrl);
    return downloadUrl;
  }
}