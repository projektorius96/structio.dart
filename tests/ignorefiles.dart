// DEV_NOTE # List of directories to ignore
import 'dart:io';

List<RegExp> ignoreDirectories = [
  RegExp(r'.\.dart_tool$'),
  RegExp(r'.\.git$'),
  // Add more directories to ignore ad-hoc...
];

bool isMatching(elementPath, ignoreList) {
  bool match = false;
  ignoreList.toList().forEach((pattern) {
    if (pattern.hasMatch(elementPath)) {
      match = true;
    }
  });
  return match;
}

void main() {
  Directory('.').listSync().forEach((element) {
    if (element is Directory) {
      /* print(element.path); */
      print(isMatching(element.path, ignoreDirectories));
    }
  });
}
