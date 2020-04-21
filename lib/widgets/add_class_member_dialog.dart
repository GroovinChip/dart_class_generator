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

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add ${widget.selectionValue}'),
      children: [
        if (widget.selectionValue == 'List')
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
        if (widget.selectionValue == 'Map')
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
        if (widget.selectionValue == 'Map')
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
        if (widget.selectionValue == 'custom type')
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
                _dataValueNameController.text = '';
                _listDataTypeController.text = '';
                _mapKeyDataTypeController.text = '';
                _mapValueDataTypeController.text = '';
                Navigator.pop(context);
              },
            ),
            FlatButton(
              textColor: Color(0xff82b1ff),
              child: Text('Finish'),
              onPressed: () {
                if (widget.selectionValue == 'List') {
                  widget.parent.setState(() {
                    widget.dartClass.members.add(
                      ClassMember(
                        name: '${_dataValueNameController.text}',
                        type: '${widget.selectionValue}<${_listDataTypeController.text}>',
                      ),
                    );
                  });
                } else if (widget.selectionValue == 'Map') {
                  widget.parent.setState(() {
                    widget.dartClass.members.add(
                      ClassMember(
                        name: '${_dataValueNameController.text}',
                        type: '${widget.selectionValue}<${_mapKeyDataTypeController.text}, ${_mapValueDataTypeController.text}>',
                      ),
                    );
                  });
                } else if (widget.selectionValue == 'custom type') {
                  widget.parent.setState(() {
                    widget.dartClass.members.add(
                      ClassMember(
                        name: '${_dataValueNameController.text}',
                        type: '${_customTypeController.text}',
                      ),
                    );
                  });
                } else {
                  widget.parent.setState(() {
                    widget.dartClass.members.add(
                      ClassMember(
                        name: '${_dataValueNameController.text}',
                        type: widget.selectionValue,
                      ),
                    );
                  });
                }
                _dataValueNameController.text = '';
                _listDataTypeController.text = '';
                _mapKeyDataTypeController.text = '';
                _mapValueDataTypeController.text = '';
                _customTypeController.text = '';
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
