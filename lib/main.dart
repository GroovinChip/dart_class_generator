import 'package:dartclassgenerator/breakpoints.dart';
import 'package:dartclassgenerator/class_member_model.dart';
import 'package:dartclassgenerator/class_model.dart';
import 'package:dartclassgenerator/code_view.dart';
import 'package:dartclassgenerator/mobile_code_view.dart';
import 'package:dartclassgenerator/settings_bloc.dart';
import 'package:dartclassgenerator/settings_dialog.dart';
import 'package:dartclassgenerator/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

//todo: MAJOR code cleanup
//todo: bug - backspacing class name until field is empty crashes code viewer. Oddly, clearing the field via the button does not.
//todo: bug - dividers do not show on web
//todo: disallow duplicate members
//todo: functions?
//todo: export code screenshot
//todo: export to gist, dartpad, codepen
//todo: default values for members
//todo: generate instantiated classes
//todo: create, save, load class templates
//todo: save as draft
//todo: add toString() (in progress)
//todo: recase
//todo: annotations
//todo: support factories
//todo: add JSON Serializable stuff
//todo: dynamic font selection
//todo: editable code view font size
//todo: readonly code view font
//todo: persist user settings
//todo: show changelog on update?
//todo: prompt user to download update on Windows, Android (?)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _settings = SettingsBloc();
    return Provider(
      create: (_) => _settings,
      child: MaterialApp(
        title: 'Dart Class Generator',
        theme: ThemeData(
          primaryColor: Color(0xff2962ff),
          accentColor: Color(0xff4d82cb),
          textSelectionHandleColor: Color(0xff4d82cb),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Color(0xff2962ff),
          accentColor: Color(0xff4d82cb),
          textSelectionHandleColor: Color(0xff82b1ff),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        themeMode: ThemeMode.dark,
        home: GeneratorHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class GeneratorHomePage extends StatefulWidget {
  @override
  _GeneratorHomePageState createState() => _GeneratorHomePageState();
}

class _GeneratorHomePageState extends State<GeneratorHomePage> {
  //bool _isClassSerializable = false;
  String classDartDoc;
  bool _withConstConstructor = false;
  bool _withNamedParameters = false;
  bool _useFinalMembers = false;
  bool _withToString = false;

  DartClass _class;

  TextEditingController _classNameController;
  TextEditingController _classDartdocController;
  TextEditingController _dataValueNameController = TextEditingController();
  TextEditingController _listDataTypeController = TextEditingController();
  TextEditingController _mapKeyDataTypeController = TextEditingController();
  TextEditingController _mapValueDataTypeController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();

  bool showLineNumbers = true;

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
    final _settingsBloc = Provider.of<SettingsBloc>(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= kTabletBreakpoint) {
          double _classCreatorWidth;
          bool _isTablet;
          if (constraints.maxWidth >= kDesktopBreakpoint) {
            _classCreatorWidth = kDesktopClassCreatorWidth;
            _isTablet = false;
          } else {
            _classCreatorWidth = kTabletClassCreatorWidth;
            _isTablet = true;
          }
          ;
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
                FlatButton.icon(
                  icon: Icon(Icons.content_copy),
                  label: Text('Copy Code'),
                  onPressed: () async {
                    ///seems to not work on windows :(
                    ///todo: investigate
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
                  icon: Icon(MdiIcons.cogOutline),
                  label: Text('Settings'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => SettingsDialog(),
                    );
                  },
                ),
              ],
            ),
            body: Row(
              children: [
                Container(
                  width: _classCreatorWidth,
                  child: Column(
                    children: [
                      GroovinExpansionTile(
                        title: Text('Basics'),
                        initiallyExpanded: true,
                        children: [
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
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  tooltip: 'Clear',
                                  onPressed: () {
                                    _classNameController.clear();
                                  },
                                ),
                              ),
                            ),
                          ),
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
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  tooltip: 'Clear',
                                  onPressed: () {
                                    setState(() {
                                      _classDartdocController.clear();
                                      _classDartdocController
                                        ..value = TextEditingValue(text: '///')
                                        ..selection =
                                            TextSelection.collapsed(offset: 3);
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
                      ListTile(
                        title: Text('Class Members'),
                        trailing: PopupMenuButton(
                          child: FlatButton.icon(
                            disabledTextColor: Colors.white,
                            icon: Icon(Icons.add),
                            label: Text('Add'),
                          ),
                          tooltip: 'Add Attribute',
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        labelText: 'Value type',
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
                                      labelText: 'Attribute name',
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
                                                name:
                                                    '${_dataValueNameController.text}',
                                                type:
                                                    '$value<${_listDataTypeController.text}>',
                                              ),
                                            );
                                          });
                                        } else if (value == 'Map') {
                                          setState(() {
                                            _class.members.add(
                                              ClassMember(
                                                name:
                                                    '${_dataValueNameController.text}',
                                                type:
                                                    '$value<${_mapKeyDataTypeController.text}, ${_mapValueDataTypeController.text}>',
                                              ),
                                            );
                                          });
                                        } else {
                                          setState(() {
                                            _class.members.add(
                                              ClassMember(
                                                name:
                                                    '${_dataValueNameController.text}',
                                                type: value,
                                              ),
                                            );
                                          });
                                        }
                                        _dataValueNameController.text = '';
                                        _listDataTypeController.text = '';
                                        _mapKeyDataTypeController.text = '';
                                        _mapValueDataTypeController.text = '';
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _class.members.length,
                          itemBuilder: (context, index) {
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
                                  itemBuilder: (_) => [
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
                                  ],
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Dartdoc':
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            TextEditingController
                                                _memberDartdocController =
                                                TextEditingController(
                                                    text: '///');
                                            return SimpleDialog(
                                              title: Text(
                                                  'Add dartdoc to ${_class.members[index].type} ${_class.members[index].name}'),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 8,
                                                          bottom: 8),
                                                  child: TextField(
                                                    controller:
                                                        _memberDartdocController,
                                                    onChanged: (dDoc) {
                                                      setState(() {
                                                        _class.members[index]
                                                            .dartdoc = dDoc;
                                                      });
                                                    },
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      labelText:
                                                          'Class dartdoc',
                                                      suffixIcon: IconButton(
                                                        icon: Icon(Icons.clear),
                                                        tooltip: 'Clear',
                                                        onPressed: () {
                                                          setState(() {
                                                            _memberDartdocController
                                                                .clear();
                                                            _memberDartdocController
                                                              ..value =
                                                                  TextEditingValue(
                                                                      text:
                                                                          '///')
                                                              ..selection =
                                                                  TextSelection
                                                                      .collapsed(
                                                                          offset:
                                                                              3);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    FlatButton(
                                                      textColor:
                                                          Theme.of(context)
                                                              .accentColor,
                                                      child: Text('Add'),
                                                      onPressed: () {
                                                        setState(() {
                                                          _class.members[index]
                                                                  .dartdoc =
                                                              _memberDartdocController
                                                                  .text;
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
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(width: 0),
                Expanded(
                  child: Center(
                    child: Card(
                      elevation: !_isTablet ? 6 : 0,
                      child: Container(
                        height: !_isTablet
                            ? constraints.maxHeight / 1.5
                            : constraints.maxHeight,
                        width: !_isTablet
                            ? constraints.maxWidth / 2
                            : constraints.maxWidth,
                        child: StreamBuilder(
                          stream: CombineLatestStream.combine3(
                            _settingsBloc.lineNumbersStream,
                            _settingsBloc.codeFontSizeStream,
                            _settingsBloc.codeEditingStream,
                                (bool lineNumsOn, double fontSize, bool codeEditingOn) => [
                              lineNumsOn,
                              fontSize,
                              codeEditingOn,
                            ],
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
                ),
              ],
            ),
          );
        } else if (constraints.maxWidth >= kTabletBreakpoint) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(appTitle),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(appTitle),
              actions: [],
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
                            controller: _classNameController,
                            onChanged: (name) {
                              setState(() {
                                _class.name = name;
                              });
                            },
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
                                  _classNameController.clear();
                                },
                              ),
                            ),
                          ),
                        ),
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
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                tooltip: 'Clear',
                                onPressed: () {
                                  setState(() {
                                    _classDartdocController.clear();
                                    _classDartdocController
                                      ..value = TextEditingValue(text: '///')
                                      ..selection =
                                          TextSelection.collapsed(offset: 3);
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
                      ],
                    ),
                    Divider(height: 0),
                    ListTile(
                      title: Text('Class Members'),
                      trailing: PopupMenuButton(
                        child: FlatButton.icon(
                          disabledTextColor: Colors.white,
                          icon: Icon(Icons.add),
                          label: Text('Add'),
                        ),
                        tooltip: 'Add Attribute',
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  autofocus: true,
                                  controller: _dataValueNameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Attribute name',
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
                                              name:
                                                  '${_dataValueNameController.text}',
                                              type:
                                                  '$value<${_listDataTypeController.text}>',
                                            ),
                                          );
                                        });
                                      } else if (value == 'Map') {
                                        setState(() {
                                          _class.members.add(
                                            ClassMember(
                                              name:
                                                  '${_dataValueNameController.text}',
                                              type:
                                                  '$value<${_mapKeyDataTypeController.text}, ${_mapValueDataTypeController.text}>',
                                            ),
                                          );
                                        });
                                      } else {
                                        setState(() {
                                          _class.members.add(
                                            ClassMember(
                                              name:
                                                  '${_dataValueNameController.text}',
                                              type: value,
                                            ),
                                          );
                                        });
                                      }
                                      _dataValueNameController.text = '';
                                      _listDataTypeController.text = '';
                                      _mapKeyDataTypeController.text = '';
                                      _mapValueDataTypeController.text = '';
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                            itemBuilder: (_) => [
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
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 'Dartdoc':
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      TextEditingController
                                          _memberDartdocController =
                                          TextEditingController(text: '///');
                                      return SimpleDialog(
                                        title: Text(
                                            'Add dartdoc to ${_class.members[index].type} ${_class.members[index].name}'),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 8,
                                                bottom: 8),
                                            child: TextField(
                                              controller:
                                                  _memberDartdocController,
                                              onChanged: (dDoc) {
                                                setState(() {
                                                  _class.members[index]
                                                      .dartdoc = dDoc;
                                                });
                                              },
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                labelText: 'Class dartdoc',
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  tooltip: 'Clear',
                                                  onPressed: () {
                                                    setState(() {
                                                      _memberDartdocController
                                                          .clear();
                                                      _memberDartdocController
                                                        ..value =
                                                            TextEditingValue(
                                                                text: '///')
                                                        ..selection =
                                                            TextSelection
                                                                .collapsed(
                                                                    offset: 3);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              FlatButton(
                                                textColor: Theme.of(context)
                                                    .accentColor,
                                                child: Text('Add'),
                                                onPressed: () {
                                                  setState(() {
                                                    _class.members[index]
                                                            .dartdoc =
                                                        _memberDartdocController
                                                            .text;
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
      },
    );
  }
}
