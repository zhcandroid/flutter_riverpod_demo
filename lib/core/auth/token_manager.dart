import 'package:flutter_riverpod_demo/core/utils/sharedprefs_utils.dart';

import '../../app/values/sp_keys.dart';

/// TokenManage

class TokenManager {
  static Future saveToken(String token) async {
    SharedPrefsUtils.putString(SharedPrefsKeys.userToken, token);
  }
  static Future<String?> getToken() async {
    return await SharedPrefsUtils.getString(SharedPrefsKeys.userToken);
  }
}
