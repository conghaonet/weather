import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'util.dart';

class PermissionUtil {
  static Future<PermissionGroup> requestPermissions(ScaffoldState scaffoldState, List<PermissionGroup> permissions, String promptMsg, {bool showPrompt = true, SnackBarAction action}) async {
    PermissionGroup deniedPermission;
    Map<PermissionGroup, PermissionStatus> mapPermissions = await PermissionHandler().requestPermissions(permissions);
    for(var permission in mapPermissions.keys) {
      if(mapPermissions[permission] == PermissionStatus.denied) {
        deniedPermission = permission;
        break;
      }
    }
    if(showPrompt && deniedPermission != null) {
      bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(deniedPermission);
      if(!isShown) {
        showPermissionPrompt(scaffoldState, deniedPermission, promptMsg: promptMsg, action: action);
      }
    }

    return deniedPermission;
  }
  static showPermissionPrompt(ScaffoldState scaffoldState, PermissionGroup permissionGroup, {String promptMsg, SnackBarAction action}) async {
    bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(permissionGroup);
    if(!isShown) {
      Util.showSnackBar(scaffoldState, strContent: promptMsg, action: action);
    }
  }

}
