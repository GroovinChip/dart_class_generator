import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_chooser/file_chooser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_ex/path_provider_ex.dart';

class DartFileStorage {
  final String dartClassName;
  final List<StorageInfo> storageInfo;
  String androidFilePath;

  DartFileStorage({
    this.dartClassName,
    this.storageInfo,
  });

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$dartClassName.dart');
  }

  /// Create a public application directory
  Future<String> get _localPathForAndroid async {
    final externalDir = storageInfo[0];
    final dataDir = Directory(p.join(externalDir.rootDir, 'DartClassGenerator'));
    await dataDir.create(recursive: true);
    androidFilePath = dataDir.path;
    return dataDir.path;
  }

  /// Store save file in public application directory
  Future<File> get _localAndroidFile {
    return _localPathForAndroid.then((path) => File(p.join(path, '$dartClassName.dart')));
  }

  /// Save dart file appropriately per platform.
  /// `async` is for the mobile implementations.
  Future<void> saveDartFile(String dartCode) async {
    if (Platform.isWindows || Platform.isMacOS) {
      showSavePanel(suggestedFileName: '$dartClassName.dart').then((result) {
        if (!result.canceled) {
          final desktopPath = result.paths[0];
          File desktopFile = File('$desktopPath');
          desktopFile.writeAsString('$dartCode');
        }
      });
    } else if (Platform.isAndroid) {
      final androidFile = await _localAndroidFile;
      await androidFile.writeAsString('$dartCode');
    } else if (Platform.isIOS) {
      //todo: find out how iOS file storage works these days, create custom dir if possible and save path to class var
      final iosFile = await _localFile;
      await iosFile.writeAsString('$dartCode');
    }
  }
}
