import 'package:dartclassgenerator/models/class_member_model.dart';
import 'package:dartclassgenerator/models/class_model.dart';
import 'package:dartclassgenerator/widgets/clear_button.dart';
import 'package:flutter/material.dart';

class AddDartdocToClassMemberDialog extends StatefulWidget {
  AddDartdocToClassMemberDialog({
    Key key,
    this.dartClass,
    this.memberIndex,
  }) : super(key: key);

  final DartClass dartClass;
  final int memberIndex;

  @override
  _AddDartdocToClassMemberDialogState createState() => _AddDartdocToClassMemberDialogState();
}

class _AddDartdocToClassMemberDialogState extends State<AddDartdocToClassMemberDialog> {
  TextEditingController _memberDartdocController;
  List<ClassMember> get members => widget.dartClass.members;
  int get memberIndex => widget.memberIndex;

  @override
  void initState() {
    super.initState();
    _initDartdocController();
  }

  void _initDartdocController() {
    if (members[memberIndex].dartdoc == null) {
      _memberDartdocController = TextEditingController(text: '///');
    } else {
      _memberDartdocController = TextEditingController(text: '${members[memberIndex].dartdoc}');
    }
  }

  void _clearDartdocField() {
    _memberDartdocController.clear();
    _memberDartdocController
      ..value = TextEditingValue(text: '///')
      ..selection = TextSelection.collapsed(offset: 3);
  }

  void _updateMemberDartdoc() {
    members[memberIndex].dartdoc = _memberDartdocController.text;
    Navigator.pop(context, members[memberIndex].dartdoc);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add dartdoc to ${members[memberIndex].type} ${members[memberIndex].name}'),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: TextField(
            controller: _memberDartdocController,
            onChanged: (dDoc) {
              setState(() {
                members[memberIndex].dartdoc = dDoc;
              });
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: 'Class dartdoc',
              suffixIcon: ClearButton(
                onPressed: _clearDartdocField,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              textColor: Theme.of(context).accentColor,
              child: Text('Add'),
              onPressed: () {
                _updateMemberDartdoc();
              },
            ),
          ],
        ),
      ],
    );
  }
}
