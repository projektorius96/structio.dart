import 'dart:io';
import 'package:structio/export.dart';

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
  final sep = Platform.pathSeparator;
  Stream<FileSystemEntity> Dirent = Directory('.').list(recursive: true);
  List<String> argv = Directory('.').absolute.path.split(sep).reversed.toList();
  final rootNamespace = "${argv[1]}$sep";
  await processStream(Dirent).then((done) async {
    var count = 0;
    rootDir.toList().forEach((FileSystemEntity dir) {
      /// print [rootNamespace] only once;
      if (count == 0) {
        print(rootNamespace);
        count++;
      }
      var splitResult = [...dir.path.split(sep)].shift();
      if (splitResult.length > 1) {
        print(
            "${getWhitespaceDepth(rootNamespace.length - 1)}$sep${splitResult[0]}"
        );
      }
    });
  });
  subrootDir.toList().forEach((FileSystemEntity dir) {
    print("${dir.path}$sep");
    /* print(element is Directory); */ // DEV_NOTE # scan each directory and print only its files
    final subdirFiles = Directory(dir.path).listSync();
    subdirFiles.toList().forEach((element) {
      if (element is File) {
        print(
            "${getWhitespaceDepth(element.parent.path.length)}${element.path.replaceFirst(element.parent.path, "")}");
      }
    });
  });
}
