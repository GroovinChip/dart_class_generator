import 'package:dartclassgenerator/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

//todo: setting for default DateTime format
class SettingsDialog extends StatefulWidget {
  SettingsDialog({Key key}) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  TextEditingController _fontSizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _settingsBloc = Provider.of<SettingsBloc>(context);
    return StreamBuilder(
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
        return SimpleDialog(
          title: Text('Settings'),
          children: [
            SwitchListTile(
              value: _lineNumsOn,
              title: Text('Show line numbers'),
              onChanged: (linesOn) {
                _settingsBloc.lineNumbersOn.add(linesOn);
              },
              activeColor: Theme.of(context).accentColor,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: TextFormField(
                controller: _fontSizeController,
                //keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Default: $_fontSize (numbers only!)',
                ),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  textColor: Theme.of(context).accentColor,
                  child: Text('Done'),
                  onPressed: () {
                    if (_fontSizeController.text.isNotEmpty) {
                      double _fs = double.parse(_fontSizeController.text);
                      if (_fs >= 10 && _fs <= 40) {
                        _settingsBloc.fontSize.add(_fs);
                      }
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
