import 'dart:io';
import 'package:dartclassgenerator/editor_settings/editor_settings_bloc.dart';
import 'package:dartclassgenerator/editor_settings/editor_settings_dialog.dart';
import 'package:dartclassgenerator/models/class_model.dart';
import 'package:dartclassgenerator/utilities/file_storage/dart_file_storage.dart';
import 'package:dartclassgenerator/utilities/permission_checker.dart';
import 'package:flutter/material.dart' hide Intent, Action;
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:intent/action.dart';
import 'package:intent/intent.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MobileCodeView extends StatefulWidget {
  MobileCodeView({
    Key key,
    this.dartClass,
    @required this.data,
    this.onChanged,
    @required this.ext,
  }) : super(key: key);

  final DartClass dartClass;
  final String data;
  final String ext;
  final ValueChanged<String> onChanged;

  @override
  _MobileCodeViewState createState() => _MobileCodeViewState();
}

class _MobileCodeViewState extends State<MobileCodeView> {
  final _controller = CodeEditingController();
  List<StorageInfo> _storageInfo = [];
  DartFileStorage dartFileStorage;
  PermissionChecker permissionChecker = PermissionChecker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Get mobile storage information
  Future<void> _getStorageInfo() async {
    List<StorageInfo> storageInfo;
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}

    if (!mounted) return;

    setState(() {
      _storageInfo = storageInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    _getStorageInfo();
    _controller.text = widget.data;
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(_controller.text);
    }
  }

  @override
  void didUpdateWidget(MobileCodeView oldWidget) {
    if (oldWidget.data != widget.data) {
      if (widget.data != _controller.text) {
        _controller.text = widget.data;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Save dart file to device storage using utility
  void _initStorage() {
    dartFileStorage = DartFileStorage(
      dartClassName: widget.dartClass.name,
      storageInfo: _storageInfo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _settingsBloc = Provider.of<EditorSettingsBloc>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.dartClass.name} Code'),
        actions: [
          PopupMenuButton(
            tooltip: 'Options',
            itemBuilder: (_) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(MdiIcons.download),
                    SizedBox(width: 8),
                    Text('Download dart file'),
                  ],
                ),
                value: 'DownloadDartFile',
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.content_copy),
                    SizedBox(width: 8),
                    Text('Copy Code'),
                  ],
                ),
                value: 'CopyCode',
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(MdiIcons.cogOutline),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
                value: 'Settings',
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'DownloadDartFile':
                  if (Platform.isAndroid) {
                    permissionChecker
                        .checkStoragePermission()
                        .then((PermissionStatus storagePermission) {
                      if (storagePermission.isGranted) {
                        _initStorage();
                        dartFileStorage
                            .saveDartFile(widget.dartClass.toString())
                            .then((value) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.dartClass.name}.dart saved to ${dartFileStorage.androidFilePath}',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'Open',
                                textColor: Colors.white,
                                onPressed: () => Intent()..setData(Uri.parse(dartFileStorage.androidFilePath))..putExtra('org.openintents.extra.ABSOLUTE_PATH', dartFileStorage.androidFilePath)..setType('resource/folder')..setAction(Action.ACTION_VIEW)..startActivity(),
                              ),
                            ),
                          );
                        });
                      } else if (storagePermission.isDenied) {
                        openAppSettings();
                      }
                    });
                  } else if (Platform.isIOS) {
                    //todo: implement iOS behavior
                  } else if (Platform.isWindows) {
                    _initStorage();
                    dartFileStorage.saveDartFile(widget.dartClass.toString());
                  }
                  break;
                case 'CopyCode':
                  Clipboard.setData(
                    ClipboardData(
                      text: formatDart(
                        widget.dartClass.toString(),
                      ),
                    ),
                  );
                  break;
                case 'Settings':
                  showDialog(
                    context: context,
                    builder: (_) => EditorSettingsDialog(),
                  );
                  break;
                default:
                  break;
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
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
          Syntax _syntax = Syntax.DART;
          if (widget.ext != null) {
            if (widget.ext == 'kt') {
              _syntax = Syntax.KOTLIN;
            }
            if (widget.ext == 'dart') {
              _syntax = Syntax.DART;
            }
            if (widget.ext == 'swift') {
              _syntax = Syntax.SWIFT;
            }
            if (widget.ext == 'js' ||
                widget.ext == 'ts' ||
                widget.ext == 'jsx') {
              _syntax = Syntax.JAVASCRIPT;
            }
            if (widget.ext == 'java') {
              _syntax = Syntax.JAVA;
            }
          }
          final _theme =
              !isDark ? SyntaxTheme.standard() : SyntaxTheme.oceanSunset();
          return !_codeEditingOn
              ? SyntaxView(
                  code: _controller.text,
                  syntax: _syntax,
                  syntaxTheme: _theme,
                  withZoom: true,
                  withLinesCount: _lineNumsOn,
                  fontSize: _fontSize,
                )
              : SyntaxEditableView(
                  syntax: Syntax.DART,
                  syntaxTheme: _theme,
                  controller: _controller,
                  withZoom: true,
                  withLinesCount: _lineNumsOn,
                );
        },
      ),
    );
  }
}
