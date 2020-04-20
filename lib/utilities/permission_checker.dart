import 'package:permission_handler/permission_handler.dart';

/// This utility handles checking the status of, and requests for, mobile application permissions.
class PermissionChecker {
  /// Storage permission
  PermissionStatus storagePermission;

  /// Check the storage permission. If undetermined,
  Future<PermissionStatus> checkStoragePermission() async {
    storagePermission = await Permission.storage.status;
    if (storagePermission.isUndetermined) {
      _requestStoragePermission();
    }
    return storagePermission;
  }

  /// Handle requesting the storage permission
  Future<void> _requestStoragePermission() async {
    await Permission.storage.request();
  }
}