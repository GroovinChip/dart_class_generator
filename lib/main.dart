import 'package:dartclassgenerator/breakpoints.dart';
import 'package:dartclassgenerator/editor_settings/editor_settings_bloc.dart';
import 'package:dartclassgenerator/ui_modes/desktop_ui.dart';
import 'package:dartclassgenerator/ui_modes/mobile_ui.dart';
import 'package:dartclassgenerator/ui_modes/tablet_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
//todo: allow adding asserts
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
  runApp(DartClassGeneratorApp());
}

class DartClassGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _settings = EditorSettingsBloc();
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

class GeneratorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= kDesktopBreakpoint) {
          return DesktopUI(constraints: constraints);
        } else if (constraints.maxWidth >= kTabletBreakpoint) {
          return TabletUI(constraints: constraints);
        } else {
          return MobileUI();
        }
      },
    );
  }
}
