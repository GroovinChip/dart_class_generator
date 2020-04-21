import 'package:dartclassgenerator/models/class_member_model.dart';
import 'package:dartclassgenerator/models/class_model.dart';
import 'package:flutter/material.dart';

class AddClassMemberDialog extends StatefulWidget {
  AddClassMemberDialog({
    Key key,
    this.parent,
    this.dartClass,
    this.selectionValue,
  }) : super(key: key);

  final State parent;
  final DartClass dartClass;
  final dynamic selectionValue;

  @override
  _AddClassMemberDialogState createState() => _AddClassMemberDialogState();
}

class _AddClassMemberDialogState extends State<AddClassMemberDialog> {
  TextEditingController _listDataTypeController = TextEditingController();
  TextEditingController _mapKeyDataTypeController = TextEditingController();
  TextEditingController _mapValueDataTypeController = TextEditingController();
  TextEditingController _customTypeController = TextEditingController();
  TextEditingController _dataValueNameController = TextEditingController();

  State get parentState => widget.parent;

  DartClass get dartClass => widget.dartClass;

  List<ClassMember> get members => dartClass.members;

  dynamic get selectionValue => widget.selectionValue;

  // Add class member, close dialog
  void _addClassMember(BuildContext context) {
    if (selectionValue == 'List') {
      _addListMember();
    } else if (widget.selectionValue == 'Map') {
      _addMapMember();
    } else if (widget.selectionValue == 'custom type') {
      _addCustomTypeMember();
    } else {
      _addSimpleMember();
    }
    _dataValueNameController.text = '';
    _listDataTypeController.text = '';
    _mapKeyDataTypeController.text = '';
    _mapValueDataTypeController.text = '';
    _customTypeController.text = '';
    Navigator.pop(context);
  }

  // A regular data type, like String or int
  void _addSimpleMember() {
    parentState.setState(() {
      members.add(
        ClassMember(
          name: '${_dataValueNameController.text}',
          type: widget.selectionValue,
        ),
      );
    });
  }

  // A custom data type
  void _addCustomTypeMember() {
    parentState.setState(() {
      members.add(
        ClassMember(
          name: '${_dataValueNameController.text}',
          type: '${_customTypeController.text}',
        ),
      );
    });
  }

  // Map type
  void _addMapMember() {
    parentState.setState(() {
      widget.dartClass.members.add(
        ClassMember(
          name: '${_dataValueNameController.text}',
          type: '$selectionValue<${_mapKeyDataTypeController.text}, ${_mapValueDataTypeController.text}>',
        ),
      );
    });
  }

  // List type
  void _addListMember() {
    parentState.setState(() {
      members.add(
        ClassMember(
          name: '${_dataValueNameController.text}',
          type: '$selectionValue<${_listDataTypeController.text}>',
        ),
      );
    });
  }

  // Reset controllers, close dialog
  void _cancel(BuildContext context) {
    _dataValueNameController.text = '';
    _listDataTypeController.text = '';
    _mapKeyDataTypeController.text = '';
    _mapValueDataTypeController.text = '';
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add $selectionValue'),
      children: [
        if (selectionValue == 'List')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              controller: _listDataTypeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Data type',
              ),
            ),
          ),
        if (selectionValue == 'Map')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              controller: _mapKeyDataTypeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Key type',
              ),
            ),
          ),
        if (selectionValue == 'Map')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _mapValueDataTypeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Value type',
              ),
            ),
          ),
        if (selectionValue == 'custom type')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              controller: _customTypeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Data type',
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            autofocus: true,
            controller: _dataValueNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: 'Member name',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                _cancel(context);
              },
            ),
            FlatButton(
              textColor: Color(0xff82b1ff),
              child: Text('Finish'),
              onPressed: () {
                _addClassMember(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
