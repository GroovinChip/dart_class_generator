import 'package:dartclassgenerator/code_views/mobile_code_view.dart';
import 'package:dartclassgenerator/models/class_member_model.dart';
import 'package:dartclassgenerator/models/class_model.dart';
import 'package:dartclassgenerator/strings.dart';
import 'package:dartclassgenerator/widgets/add_class_member_dialog.dart';
import 'package:dartclassgenerator/widgets/add_dartdoc_to_class_member_dialog.dart';
import 'package:dartclassgenerator/widgets/clear_button.dart';
import 'package:dartclassgenerator/widgets/popup_menu_lists.dart';
import 'package:dartclassgenerator/widgets/mobile_main_overflow_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileUI extends StatefulWidget {
  MobileUI({Key key}) : super(key: key);

  @override
  _MobileUIState createState() => _MobileUIState();
}

class _MobileUIState extends State<MobileUI> {
  //bool _isClassSerializable = false;
  String classDartDoc;
  bool _withConstConstructor = false;
  bool _withNamedParameters = false;

  DartClass _class;

  TextEditingController _classNameController;
  TextEditingController _classDartdocController;

  @override
  void initState() {
    super.initState();
    final defaultName = 'MyClass';
    _class = DartClass(
      name: defaultName,
      isConst: _withConstConstructor,
      hasNamedParameters: _withNamedParameters,
      members: [],
    );
    // listen to dartdoc textfield
    _classDartdocController = TextEditingController();
    _classDartdocController.addListener(() {
      setState(() => _class.dartdoc = _classDartdocController.text);
    });

    // listen to class name textfield
    _classNameController = TextEditingController(text: defaultName);
    _classNameController.addListener(() {
      setState(() => _class.name = _classNameController.text);
    });
  }

  void _clearClassDartdocField() {
    _classDartdocController.clear();
  }

  void _clearClassNameField() {
    _classNameController.clear();
  }

  Future _showAddMemberDialog(BuildContext context, value) async {
    List<ClassMember> _members = await showDialog<List<ClassMember>>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          AddClassMemberDialog(
            dartClass: _class,
            selectionValue: value,
          ),
    );
    setState(() {
      _class.members = _members;
    });
  }

  Future _showMemberDartdocDialog(BuildContext context, int index) async {
    String _dartDoc = await showDialog<String>(
      context: context,
      builder: (context) {
        return AddDartdocToClassMemberDialog(
          dartClass: _class,
          memberIndex: index,
        );
      },
    );
    setState(() {
      _class.members[index].dartdoc = _dartDoc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [MobileMainOverflowMenu()],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              GroovinExpansionTile(
                title: Text('Basics'),
                initiallyExpanded: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _classDartdocController,
                      onChanged: (dDoc) {
                        setState(() {
                          _class.dartdoc = dDoc;
                        });
                      },
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Class dartdoc',
                        suffixIcon: ClearButton(
                          onPressed: _clearClassDartdocField,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _classNameController,
                      onChanged: (name) {
                        setState(() {
                          _class.name = name;
                        });
                      },
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Class name',
                        suffixIcon: ClearButton(
                          onPressed: _clearClassNameField,
                        ),
                      ),
                    ),
                  ),
                  SwitchListTile(
                    value: _class.isConst,
                    onChanged: (val) {
                      setState(() {
                        _class.isConst = val;
                      });
                    },
                    title: Text('Use Const Constructor'),
                    activeColor: Theme.of(context).accentColor,
                  ),
                  SwitchListTile(
                    value: _class.hasNamedParameters,
                    onChanged: _class.members.isEmpty
                        ? null
                        : (val) {
                            setState(() {
                              _class.hasNamedParameters = val;
                            });
                          },
                    title: Text('Use Named Parameters'),
                    activeColor: Theme.of(context).accentColor,
                  ),
                  SwitchListTile(
                    value: _class.allMembersFinal,
                    title: Text('Use Final Members'),
                    activeColor: Theme.of(context).accentColor,
                    onChanged: _class.members.isEmpty
                        ? null
                        : (val) {
                            setState(() {
                              _class.allMembersFinal = val;
                            });
                          },
                  ),
                  SwitchListTile(
                    value: _class.withToString,
                    title: Text('Override toString()'),
                    activeColor: Theme.of(context).accentColor,
                    onChanged: _class.members.isEmpty
                        ? null
                        : (val) {
                      setState(() {
                        _class.withToString = val;
                      });
                    },
                  ),
                ],
              ),
              Divider(height: 0),
              ListTile(
                title: Text('Class Members'),
                trailing: PopupMenuButton(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 16, top: 8, bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Add Class Member'),
                      ],
                    ),
                  ),
                  tooltip: 'Add Attribute',
                  itemBuilder: (_) => classMemberTypes,
                  onSelected: (value) async {
                    await _showAddMemberDialog(context, value);
                  },
                ),
              ),
            ]),
          ),
          SliverFillViewport(
            viewportFraction: 0.1,
            padEnds: false,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                ClassMember member = _class.members[index];
                return ListTileTheme(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 0,
                      bottom: 0,
                    ),
                    title: Text('${member.type} ${member.name}'),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (_) => classMemberOptions,
                      onSelected: (value) async {
                        switch (value) {
                          case 'Dartdoc':
                            await _showMemberDartdocDialog(context, index);
                            break;
                          case 'Required':
                            if (member.isRequired == false) {
                              setState(() {
                                member.isRequired = true;
                              });
                            } else {
                              setState(() {
                                member.isRequired = false;
                              });
                            }
                            break;
                          case 'Private':
                            if (member.isPrivate == false) {
                              setState(() {
                                member.isPrivate = true;
                              });
                            } else {
                              setState(() {
                                member.isPrivate = false;
                              });
                            }
                            break;
                          case 'Remove':
                            setState(() {
                              _class.members.removeAt(index);
                            });
                            break;
                          default:
                            break;
                        }
                      },
                    ),
                  ),
                );
              },
              childCount: _class.members.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        tooltip: 'View Code',
        child: Icon(MdiIcons.codeBraces),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MobileCodeView(
              dartClass: _class,
              data: _class.toString(),
              ext: 'dart',
            ),
          ),
        ),
      ),
    );
  }
}
