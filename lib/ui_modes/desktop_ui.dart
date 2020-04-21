import 'package:dartclassgenerator/breakpoints.dart';
import 'package:dartclassgenerator/code_views/code_view.dart';
import 'package:dartclassgenerator/editor_settings/editor_settings_bloc.dart';
import 'package:dartclassgenerator/editor_settings/editor_settings_dialog.dart';
import 'package:dartclassgenerator/models/class_member_model.dart';
import 'package:dartclassgenerator/models/class_model.dart';
import 'package:dartclassgenerator/strings.dart';
import 'package:dartclassgenerator/widgets/popup_menu_lists.dart';
import 'package:dartclassgenerator/widgets/main_overflow_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class DesktopUI extends StatefulWidget {
  DesktopUI({
    Key key,
    @required this.constraints,
  }) : super(key: key);

  final BoxConstraints constraints;

  @override
  _DesktopUIState createState() => _DesktopUIState();
}

class _DesktopUIState extends State<DesktopUI> {
  //bool _isClassSerializable = false;
  String classDartDoc;
  bool _withConstConstructor = false;
  bool _withNamedParameters = false;

  DartClass _class;

  TextEditingController _classNameController;
  TextEditingController _classDartdocController;
  TextEditingController _dataValueNameController = TextEditingController();
  TextEditingController _listDataTypeController = TextEditingController();
  TextEditingController _mapKeyDataTypeController = TextEditingController();
  TextEditingController _mapValueDataTypeController = TextEditingController();
  TextEditingController _customTypeController = TextEditingController();

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
            width: kDesktopClassCreatorWidth,
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
                        onEditingComplete: () {
                          setState(() {
                            _class.dartdoc = _classDartdocController.text;
                          });
                        },
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Class dartdoc',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            tooltip: 'Clear',
                            onPressed: () {
                              setState(() {
                                _classDartdocController.clear();
                                _classDartdocController
                                  ..value = TextEditingValue(text: '///')
                                  ..selection = TextSelection.collapsed(offset: 3);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _classNameController,
                        onChanged: (name) {
                          if (name.isEmpty) {
                            setState(() {
                              _classNameController.clear();
                              _classDartdocController..value = TextEditingValue(text: '');
                              _class.name = null;
                            });
                          } else {
                            setState(() {
                              _class.name = name;
                            });
                          }
                        },
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Class name',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            tooltip: 'Clear',
                            onPressed: () {
                              setState(() {
                                _classNameController.clear();
                                _classDartdocController..value = TextEditingValue(text: '');
                                _class.name = null;
                              });
                            },
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
                            onSelected: (value) {
                              switch (value) {
                                case 'Dartdoc':
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      TextEditingController _memberDartdocController = TextEditingController(text: '///');
                                      return SimpleDialog(
                                        title: Text('Add dartdoc to ${_class.members[index].type} ${_class.members[index].name}'),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                            child: TextField(
                                              controller: _memberDartdocController,
                                              onChanged: (dDoc) {
                                                setState(() {
                                                  _class.members[index].dartdoc = dDoc;
                                                });
                                              },
                                              textCapitalization: TextCapitalization.words,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'Class dartdoc',
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  tooltip: 'Clear',
                                                  onPressed: () {
                                                    setState(() {
                                                      _memberDartdocController.clear();
                                                      _memberDartdocController
                                                        ..value = TextEditingValue(text: '///')
                                                        ..selection = TextSelection.collapsed(offset: 3);
                                                    });
                                                  },
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
                                                  setState(() {
                                                    _class.members[index].dartdoc = _memberDartdocController.text;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
                Row(
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
                        builder: (_) => SimpleDialog(
                          title: Text('Add $value'),
                          children: [
                            if (value == 'List')
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
                            if (value == 'Map')
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
                            if (value == 'Map')
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
                            if (value == 'custom type')
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
                                    if (value == 'List') {
                                      setState(() {
                                        _class.members.add(
                                          ClassMember(
                                            name: '${_dataValueNameController.text}',
                                            type: '$value<${_listDataTypeController.text}>',
                                          ),
                                        );
                                      });
                                    } else if (value == 'Map') {
                                      setState(() {
                                        _class.members.add(
                                          ClassMember(
                                            name: '${_dataValueNameController.text}',
                                            type: '$value<${_mapKeyDataTypeController.text}, ${_mapValueDataTypeController.text}>',
                                          ),
                                        );
                                      });
                                    } else if (value == 'custom type') {
                                      setState(() {
                                        _class.members.add(
                                          ClassMember(
                                            name: '${_dataValueNameController.text}',
                                            type: '${_customTypeController.text}',
                                          ),
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        _class.members.add(
                                          ClassMember(
                                            name: '${_dataValueNameController.text}',
                                            type: value,
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
                ),
                Spacer(),
                Center(
                  child: Card(
                    elevation: 6,
                    child: Container(
                      height: widget.constraints.maxHeight / 1.5,
                      width: widget.constraints.maxWidth / 2,
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
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
