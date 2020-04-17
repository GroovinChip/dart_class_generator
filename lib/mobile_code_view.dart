import 'package:dartclassgenerator/class_model.dart';
import 'package:dartclassgenerator/settings_bloc.dart';
import 'package:dartclassgenerator/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'code_view.dart';

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
  @override
  void initState() {
    _controller.text = widget.data;
    _controller.addListener(_onChanged);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final _settingsBloc = Provider.of<SettingsBloc>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dartClass.name} Code'),
        actions: [
          PopupMenuButton(
            tooltip: 'Options',
            itemBuilder: (_) => [
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
                    builder: (_) => SettingsDialog(),
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
          return _codeEditingOn
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
