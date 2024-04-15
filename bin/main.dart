import 'dart:io';
import 'package:structio/export.dart';

String genWhitespace(int n,
    {String currentValue = "\xa0", String prefix = "", String suffix = ""}) {
  String result = prefix;
  for (int i = 0; i < n; i++) {
    result += currentValue;
  }
  result += suffix;
  return result;
}

List<FileSystemEntity> rootDir = [];
List<FileSystemEntity> subrootDir = [];
Future<bool> processStream(Stream<dynamic> dirent) async {
  await for (var dir in dirent) {
    // Process each element asynchronously
    if (await FileSystemEntity.isDirectory(dir.path)) {
      subrootDir.push(dir);
    } else if (await FileSystemEntity.isFile(dir.path)) {
      rootDir.push(dir);
    }
  }
  return true;
}

void main(List<String> args) async {
  Stream<FileSystemEntity> Dirent = Directory('.').list(recursive: true);
  List<String> argv = Directory('.')
      .absolute
      .path
      .split(Platform.pathSeparator)
      .reversed
      .toList();
  final rootNamespace = "${argv[1]}${Platform.pathSeparator}";
  await processStream(Dirent).then((done) async {
    var count = 0;
    rootDir.forEach((element) {
      if (count == 0) {
        print(rootNamespace);
        count++;
      }
      var splitResult = [...element.path.split(Platform.pathSeparator)].shift();
      splitResult.length > 1
          ? false
          : print("${genWhitespace(rootNamespace.length-1)}${Platform.pathSeparator}${splitResult[0]}");
    });
  });
  subrootDir.forEach((element) {
    print("${element.path}${Platform.pathSeparator}");
    /* print(element is Directory); */ // DEV_NOTE # scan each directory and print only its files
    final subdirFiles = Directory(element.path).listSync();
    subdirFiles.forEach((element) {
      if (element is File) {
        print("${genWhitespace(element.parent.path.length)}${element.path.replaceFirst(element.parent.path, "")}");
      }
    });
  });
}
