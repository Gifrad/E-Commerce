import 'package:shared_preferences/shared_preferences.dart';

class GetRoles {
  static Future<String?> getRoles() async {
    final helper = await SharedPreferences.getInstance();
    final roles = helper.getString('roles');
    return roles;
  }
}