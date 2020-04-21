import 'package:flutter/material.dart';

List<PopupMenuEntry> classMemberOptions = <PopupMenuEntry>[
  PopupMenuItem(
    child: Text('Add dartdoc'),
    value: 'Dartdoc',
  ),
  PopupMenuItem(
    child: Text('Make required'),
    value: 'Required',
  ),
  PopupMenuItem(
    child: Text('Make private'),
    value: 'Private',
  ),
  PopupMenuItem(
    child: Text('Remove member'),
    value: 'Remove',
  ),
];

List<PopupMenuEntry> classMemberTypes = <PopupMenuEntry>[
  PopupMenuItem(
    child: Text('String'),
    value: 'String',
  ),
  PopupMenuItem(
    child: Text('Integer'),
    value: 'int',
  ),
  PopupMenuItem(
    child: Text('Double'),
    value: 'double',
  ),
  PopupMenuItem(
    child: Text('Boolean'),
    value: 'bool',
  ),
  PopupMenuItem(
    child: Text('List'),
    value: 'List',
  ),
  PopupMenuItem(
    child: Text('Map'),
    value: 'Map',
  ),
  PopupMenuItem(
    child: Text('DateTime'),
    value: 'DateTime',
  ),
  PopupMenuItem(
    child: Text('Custom'),
    value: 'custom type',
  ),
];
