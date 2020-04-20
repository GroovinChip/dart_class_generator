import 'dart:html';
import 'package:dartclassgenerator/models/class_model.dart';

/// Download dart file from web
void downloadDartFile(DartClass dartClass) {
  AnchorElement a = AnchorElement(href: 'data:text/plain,${Uri.encodeComponent(dartClass.toString())}');
  a..download = '${dartClass.name}.dart'..target = '_blank';
  a.click();
}