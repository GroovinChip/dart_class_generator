import 'package:dartclassgenerator/models/class_model.dart';
import 'package:dartclassgenerator/utilities/file_storage/dart_file_storage.dart';
import 'package:dartclassgenerator/utilities/file_storage/dart_file_storage_web_stub.dart'
if (dart.library.html) 'package:dartclassgenerator/utilities/file_storage/dart_file_storage_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// AppBar
class MainOverflowMenu extends StatelessWidget {
  final DartClass dartClass;

  const MainOverflowMenu({
    Key key,
    this.dartClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      tooltip: 'More',
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
              Icon(MdiIcons.github),
              SizedBox(width: 8),
              Text('Source code'),
            ],
          ),
          value: 'SourceCode',
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(MdiIcons.currencyUsd),
              SizedBox(width: 8),
              Text('Donate'),
            ],
          ),
          value: 'Donate',
        ),
      ],
      onSelected: (value) async {
        switch (value) {
          case 'DownloadDartFile':
            if (kIsWeb) {
              downloadDartFile(dartClass);
            } else {
              DartFileStorage dartFileStorage = DartFileStorage(
                dartClassName: dartClass.name,
              );
              dartFileStorage.saveDartFile(dartClass.toString());
            }
            break;
          case 'SourceCode':
            const url = 'https://github.com/GroovinChip/dart_class_generator';
            await launch(url);
            break;
          case "Donate":
            const url = 'https://github.com/sponsors/GroovinChip';
            await launch(url);
            break;
          default:
        }
      },
    );
  }
}
