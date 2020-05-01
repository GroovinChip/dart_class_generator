import 'package:flutter/material.dart';

class ClassMember {
  String dartdoc;
  String name;
  bool isFinal;
  String generic;
  String type;
  bool isRequired;
  bool isPrivate;

  ClassMember({
    this.dartdoc,
    @required this.name,
    @required this.type,
    this.isFinal = false,
    this.isRequired = false,
    this.isPrivate = false,
    this.generic,
  });

  String param() {
    final buffer = StringBuffer();
    if (isRequired) {
      buffer.write('@required ');
    }
    if (isPrivate) {
      buffer.write('$type');
      if (generic != null) {
        buffer.write('<$generic>');
      }
    }
    buffer.write(' ');
    if (!isPrivate) {
      buffer.write('this.');
    }
    buffer.write('$name');
    return buffer.toString().trim();
  }

  String postParam() {
    if (!isPrivate) return '';
    return '_$name = $name'.trim();
  }

  String field() {
    String _dartdoc;
    final sb = StringBuffer();
    if (dartdoc == null || dartdoc.isEmpty) {
      _dartdoc = 'todo: write documentation for member $name';
    } else {
      _dartdoc = dartdoc;
    }
    sb.writeln('/// $_dartdoc');
    if (isFinal) {
      sb.write('final ');
    }
    sb.write('$type');
    if (generic != null) {
      sb.write('<$generic>');
    }
    sb.write(' ');
    if (isPrivate) {
      sb.write('_');
    }
    sb.write('$name;');
    return sb.toString();
  }
}
