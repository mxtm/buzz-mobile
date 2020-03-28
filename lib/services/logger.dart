import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:buzz/services/visitors.dart';

class Logger{

  write(String first,String last,String url) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/visitors.txt');
    await file.writeAsString('$first $last,$url\n', mode: FileMode.append);
  }

  delete(List<Visitors> v) async {
    v.clear();
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/visitors.txt');
    await file.writeAsString('');
  }

  Future<String> read() async {
    String text;
    try{
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/visitors.txt');
      text = await file.readAsString();
    } catch (e){
      print("Couldn't read file");
    }
    return text;
  }

  Future<List<Visitors>> setup(List<Visitors> v) async {
    String getText;
    String image;
    String first;
    String last;
    List<String> p = ['p'];
    List<Visitors> vList;
    v.clear();
    v = [Visitors(firstName: 'f', lastName: 'l', image: 'i')];
    await read().then((text) {getText = text;});
    if (getText == null || getText == '')
    {
      return v;
    }
    else {
      p = p + getText.split('\n');
    }
    for (int i = 1; i < p.length-1; i++)
      {
        first = p[i].split(' ')[0];
        last = (p[i].split(' ')[1]).split(',')[0];
        image = (p[i].split(' ')[1]).split(',')[1];
        if (vList == null){
          vList = [Visitors(firstName: first,lastName: last,image: image)];
        }
        else{
          vList.add(Visitors(firstName: first,lastName: last,image: image));
        }
      }
    vList.sort((a,b) => (a.toString().toLowerCase()).compareTo((b.toString().toLowerCase())));
    return v + vList;
  }
}