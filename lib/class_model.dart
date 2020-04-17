import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'class_member_model.dart';

//todo: fix line formatting

class DartClass {
  DartClass({
    this.dartdoc,
    @required this.name,
    this.isConst = false,
    this.generic,
    this.hasNamedParameters = false,
    this.allMembersFinal = false,
    this.members,
    this.withToString = false,
  });

  String dartdoc;
  String name;
  bool isConst;
  String generic;
  bool allMembersFinal;
  bool hasNamedParameters;
  List<ClassMember> members;
  bool withToString;

  @override
  String toString() {
    final buffer = StringBuffer();
    final _members = members ?? [];
    final _dartdoc = dartdoc ?? '///todo: write documentation for class $name';
    buffer.writeln(_dartdoc);
    buffer.write('class $name');
    buffer.write(' {');
    if (isConst) {
      buffer.write('const ');
    }
    buffer.write('$name');
    if (generic != null) {
      buffer.write('<$generic>');
    }
    buffer.write(' (');
    if (_members.isNotEmpty && hasNamedParameters) {
      buffer.write('{');
    }
    for (final member in _members) {
      if (allMembersFinal && !member.isFinal) {
        member.isFinal = true;
        buffer.writeln('${member.param()},');
      } else if (!allMembersFinal && member.isFinal) {
        member.isFinal = false;
        buffer.writeln('${member.param()},');
      } else {
        buffer.writeln('${member.param()},');
      }
    }
    final _private = _members.where((element) => element.isPrivate).toList();
    if (_private.isNotEmpty) {
      if (_members.isNotEmpty && hasNamedParameters) {
        buffer.write('}');
      }
      buffer.write(') :');
      for (var i = 0; i < _private.length; i++) {
        final _member = _private[i];
        buffer.writeln('${_member.postParam()}');
        if (i == _private.length - 1) {
          buffer.write(';');
        } else {
          buffer.write(',');
        }
      }
    } else {
      if (_members.isNotEmpty && hasNamedParameters) {
        buffer.write('}');
      }
      buffer.write(');');
    }
    buffer.writeln();
    for (final member in _members) {
      buffer.writeln(member.field());
    }
    if (withToString) {
      buffer.writeln();
      buffer.writeln('@override');
      buffer.writeln('String toString() {');
      buffer.writeln('return \'\';');
      buffer.writeln('}');
    }
    buffer.writeln();
    buffer.write('}');
    return formatDart(buffer.toString());
  }
}

String formatDart(String code) => DartFormatter().format(code).toString();
