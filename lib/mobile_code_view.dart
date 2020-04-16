import 'package:dartclassgenerator/class_model.dart';
import 'package:dartclassgenerator/settings_bloc.dart';
import 'package:dartclassgenerator/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'code_view.dart';

class MobileCodeView extends StatefulWidget {
  MobileCodeView({Key key, this.dartClass}) : super(key: key);

  final DartClass dartClass;

  @override
  _MobileCodeViewState createState() => _MobileCodeViewState();
}

class _MobileCodeViewState extends State<MobileCodeView> {
  @override
  Widget build(BuildContext context) {
    final _settingsBloc = Provider.of<SettingsBloc>(context);
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
        stream: CombineLatestStream.combine2(
          _settingsBloc.lineNumbersStream,
          _settingsBloc.codeFontSizeStream,
              (bool lineNumsOn, double fontSize) => [
            lineNumsOn,
            fontSize,
          ],
        ),
        initialData: [
          _settingsBloc.lineNumbersStream.value,
          _settingsBloc.codeFontSizeStream.value
        ],
        builder: (context, snapshot) {
          bool _lineNumsOn = snapshot.data[0];
          double _fontSize = snapshot.data[1];
          return CodeView(
            data: widget.dartClass.toString(),
            ext: 'dart',
            edit: false,
            fontSize: _fontSize,
            showLineNumbers: _lineNumsOn,
          );
        },
      ),
    );
  }
}