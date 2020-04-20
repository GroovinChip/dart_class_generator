import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// AppBar overflow menu for mobile
class MobileMainOverflowMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      tooltip: 'More',
      itemBuilder: (_) => <PopupMenuEntry>[
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
