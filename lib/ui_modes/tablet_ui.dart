import 'package:dartclassgenerator/breakpoints.dart';
import 'package:dartclassgenerator/code_views/code_view.dart';
import 'package:dartclassgenerator/editor_settings/editor_settings_bloc.dart';
import 'package:dartclassgenerator/editor_settings/editor_settings_dialog.dart';
import 'package:dartclassgenerator/models/class_member_model.dart';
import 'package:dartclassgenerator/models/class_model.dart';
import 'package:dartclassgenerator/strings.dart';
import 'package:dartclassgenerator/widgets/add_class_member_dialog.dart';
import 'package:dartclassgenerator/widgets/add_dartdoc_to_class_member_dialog.dart';
import 'package:dartclassgenerator/widgets/clear_button.dart';
import 'package:dartclassgenerator/widgets/popup_menu_lists.dart';
import 'package:dartclassgenerator/widgets/main_overflow_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TabletUI extends StatefulWidget {
  TabletUI({
    Key key,
    @required this.constraints,
  }) : super(key: key);

  final BoxConstraints constraints;

  @override
  _TabletUIState createState() => _TabletUIState();
}

class _TabletUIState extends State<TabletUI> {
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
    _classNameController = TextEditingController(text: 'MyClass');
    _classDartdocController = TextEditingController(text: '///');
    _class = DartClass(
      name: _classNameController.text,
      isConst: _withConstConstructor,
      hasNamedParameters: _withNamedParameters,
      members: [],
    );
  }

  void _clearClassDartdocField() {
    setState(() {
      _classDartdocController.clear();
      _classDartdocController
        ..value = TextEditingValue(text: '///')
        ..selection = TextSelection.collapsed(offset: 3);
      _class.dartdoc = _classDartdocController.text;
    });
  }

  void _clearClassNameField() {
    setState(() {
      _classNameController.clear();
      _classNameController.value = TextEditingValue(text: '');
      _class.name = null;
    });
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
    final _settingsBloc = Provider.of<EditorSettingsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        /*leading: Tooltip(
                message: 'Build instantiated classes (not working yet)',
                child: IconButton(
                  icon: Icon(
                    MdiIcons.play,
                  ), //todo: make AnimatedIcon so it can show loading progress while building
                  onPressed: () {},
                ),
              ),*/
        centerTitle: true,
        title: Text(appTitle),
        actions: [
          MainOverflowMenu(dartClass: _class),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: widget.constraints.maxWidth >= 1080 ? kDesktopClassCreatorWidth : kTabletClassCreatorWidth,
            child: Column(
              children: [
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
                        textCapitalization: TextCapitalization.words,
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
                    /*SwitchListTile(
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
                          ),*/
                    /*SwitchListTile(
                            value: _isClassSerializable,
                            onChanged: (val) {
                              setState(() {
                                _isClassSerializable = val;
                              });
                            },
                            title: Text('JSON Serializable'),
                            activeColor: Theme.of(context).accentColor,
                          ),*/
                  ],
                ),
                Divider(height: 0),
                GroovinExpansionTile(
                  title: Text('Class Members'),
                  initiallyExpanded: true,
                  children: [
                    for (int index = 0; index < _class.members.length; index++)
                      ListTileTheme(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 0,
                            bottom: 0,
                          ),
                          title: Text('${_class.members[index].type} ${_class.members[index].name}'),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (_) => classMemberOptions,
                            onSelected: (value) async {
                              switch (value) {
                                case 'Dartdoc':
                                  await _showMemberDartdocDialog(context, index);
                                  break;
                                case 'Required':
                                  if (_class.members[index].isRequired == false) {
                                    setState(() {
                                      _class.members[index].isRequired = true;
                                    });
                                  } else {
                                    setState(() {
                                      _class.members[index].isRequired = false;
                                    });
                                  }
                                  break;
                                case 'Private':
                                  if (_class.members[index].isPrivate == false) {
                                    setState(() {
                                      _class.members[index].isPrivate = true;
                                    });
                                  } else {
                                    setState(() {
                                      _class.members[index].isPrivate = false;
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
                      ),
                  ],
                ),
              ],
            ),
          ),
          VerticalDivider(width: 0),
          Expanded(
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 500) {
                      return Row(
                        children: [
                          PopupMenuButton(
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
                            tooltip: 'Show options',
                            itemBuilder: (_) => classMemberTypes,
                            onSelected: (value) => showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) =>
                                  AddClassMemberDialog(
                                    dartClass: _class,
                                    selectionValue: value,
                              ),
                            ),
                          ),
                          Spacer(),
                          FlatButton.icon(
                            icon: Icon(MdiIcons.fileCode),
                            label: Text('Copy Code'),
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: formatDart(
                                    _class.toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                          FlatButton.icon(
                            icon: Icon(MdiIcons.codeTags),
                            label: Text('Editor Settings'),
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => EditorSettingsDialog(),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PopupMenuButton(
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
                            tooltip: 'Show options',
                            itemBuilder: (_) => [
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
                            ],
                            onSelected: (value) async {
                              await _showAddMemberDialog(context, value);
                            },
                          ),
                          PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (_) => [
                                    PopupMenuItem(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(MdiIcons.fileCode),
                                          SizedBox(width: 8),
                                          Text('Copy Code'),
                                        ],
                                      ),
                                      value: 'CopyCode',
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(MdiIcons.codeTags),
                                          SizedBox(width: 8),
                                          Text('Editor Settings'),
                                        ],
                                      ),
                                      value: 'EditorSettings',
                                    ),
                                  ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'CopyCode':
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: formatDart(
                                          _class.toString(),
                                        ),
                                      ),
                                    );
                                    break;
                                  case 'EditorSettings':
                                    showDialog(
                                      context: context,
                                      builder: (_) => EditorSettingsDialog(),
                                    );
                                    break;
                                  default:
                                }
                              }),
                        ],
                      );
                    }
                  },
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: CombineLatestStream.combine3(
                      _settingsBloc.lineNumbersStream,
                      _settingsBloc.codeFontSizeStream,
                      _settingsBloc.codeEditingStream,
                      (bool lineNumsOn, double fontSize, bool codeEditingOn) => [lineNumsOn, fontSize, codeEditingOn],
                    ),
                    initialData: [
                      _settingsBloc.lineNumbersStream.value,
                      _settingsBloc.codeFontSizeStream.value,
                      _settingsBloc.codeEditingStream.value,
                    ],
                    builder: (context, snapshot) {
                      bool _lineNumsOn = snapshot.data[0];
                      double _fontSize = snapshot.data[1];
                      bool _codeEditingOn = snapshot.data[2];
                      return CodeView(
                        data: _class.toString(),
                        ext: 'dart',
                        edit: _codeEditingOn,
                        fontSize: _fontSize,
                        showLineNumbers: _lineNumsOn,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
