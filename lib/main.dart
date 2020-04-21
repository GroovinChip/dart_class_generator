import 'package:dartclassgenerator/breakpoints.dart';
import 'package:dartclassgenerator/editor_settings/editor_settings_bloc.dart';
import 'package:dartclassgenerator/ui_modes/desktop_ui.dart';
import 'package:dartclassgenerator/ui_modes/mobile_ui.dart';
import 'package:dartclassgenerator/ui_modes/tablet_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          textSelectionColor: Color(0xff4d82cb),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Color(0xff2962ff),
          accentColor: Color(0xff4d82cb),
          textSelectionHandleColor: Color(0xff82b1ff),
          textSelectionColor: Color(0xff4d82cb),
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
