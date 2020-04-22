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
    String _dartdoc;

    /// write class dartdoc
    if (dartdoc == null || dartdoc.isEmpty) {
      if (name == null || name.isEmpty) {
        _dartdoc = 'TODO: write documentation for class MyClass';
      } else {
        _dartdoc = 'TODO: write documentation for class $name';
      }
    } else {
      _dartdoc = dartdoc;
    }
    buffer.writeln('/// $_dartdoc');

    /// write class name
    if (name == null || name.isEmpty) {
      buffer.write('class MyClass');
    } else {
      buffer.write('class $name');
    }

    /// write open class brace
    buffer.write(' {');

    /// Constructor
    // const
    if (isConst) {
      buffer.write('const ');
    }

    // constructor name
    if (name == null || name.isEmpty) {
      buffer.write('MyClass');
    } else {
      buffer.write('$name');
    }

    // generic
    if (generic != null) {
      buffer.write('<$generic>');
    }

    // write open constructor paren/brace
    buffer.write(' (');
    if (_members.isNotEmpty && hasNamedParameters) {
      buffer.write('{');
    }

    // write class parameters
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

    // write private parameters
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
      // write closing constructor paren/brace
      if (_members.isNotEmpty && hasNamedParameters) {
        buffer.write('}');
      }
      buffer.write(');');
    }

    /// Write blank line between constructor and class members
    buffer.writeln();

    /// Write class members
    for (final member in _members) {
      buffer.writeln(member.field());
    }

    /// Write toString()
    if (withToString) {
      buffer.writeln();
      buffer.writeln('@override');
      buffer.writeln('String toString() {');
      buffer.write('return ');
      buffer.write('\'$name{');
      for (int i = 0; i < _members.length; i++) {
        buffer.write('${_members[i].name} \$${_members[i].name}');
        if (i != _members.length - 1) {
          buffer.write(', ');
        }
      }
      buffer.write('}\'');
      buffer.write(';');
      //buffer.writeln('return ${'some text'};');
      buffer.writeln('}');
    }

    /// Write blank line
    buffer.writeln();

    /// Write closing class brace
    buffer.write('}');

    //print(buffer.toString());

    /// return dart-formatted class as String
    return formatDart(buffer.toString());
  }
}

/// Format a given string as Dart code
String formatDart(String code) => DartFormatter().format(code).toString();
