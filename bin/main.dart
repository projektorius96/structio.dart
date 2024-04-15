import 'dart:io';
import 'package:structio/export.dart';

// DEV_NOTE # List of directories to ignore
List<RegExp> ignoreList = [
  RegExp(r'.\.git'),
  RegExp(r'.\.dart_tool'),
  // Add more directories to ignore ad-hoc...
];
List<FileSystemEntity> rootDir = [];
List<FileSystemEntity> subrootDir = [];
Future<bool> processStream(Stream<dynamic> dirent) async {
  processing:
  await for (var dir in dirent) {
    if (await FileSystemEntity.isDirectory(dir.path)) {
      if (hasMatched(dir.path, ignoreList)) {
        continue processing;
      } else {
        subrootDir.push(dir);
      }
    } else if (await FileSystemEntity.isFile(dir.path)) {
      rootDir.push(dir);
    }
  }
  return true;
}

void main(List<String> args) async {
  final sep = Platform.pathSeparator;
  Stream<FileSystemEntity> dirent = Directory('.').list(recursive: true);
  List<String> argv = Directory('.').absolute.path.split(sep).reversed.toList();
  final rootNamespace = "${argv[1]}$sep";
  await processStream(dirent).then((done) async {
    var count = 0;
    rootDir.toList().forEach((FileSystemEntity dir) {
      /// print [rootNamespace] only once;
      if (count == 0) {
        print(rootNamespace);
        count++;
      }
      var splitResult = [...dir.path.split(sep)].shift();
      splitResult.length > 1
          ? false
          : print(
              "${getWhitespaceDepth(rootNamespace.length - 1)}$sep${splitResult[0]}");
    });
  });
  subrootDir.toList().forEach((FileSystemEntity dir) {
    print("${dir.path}$sep");
    final subdirFiles = Directory(dir.path).listSync();
    subdirFiles.toList().forEach((element) {
      if (element is File) {
        print(
            "${getWhitespaceDepth(element.parent.path.length)}${element.path.replaceFirst(element.parent.path, "")}");
      }
    });
  });
}
