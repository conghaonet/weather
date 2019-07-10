import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../strings.dart';
import '../translations.dart';


class AppSnackBarAction {
  static SnackBarAction getDefaultPermissionAction(BuildContext context, {String label, Function onPressed}) {
    String _strLabel = label ?? Translations.of(context).getString(Strings.permissionGotoSettings);
    SnackBarAction _action = SnackBarAction(
      label: _strLabel,
      onPressed: onPressed ?? () {PermissionHandler().openAppSettings();},
    );
    return _action;
  }
}
