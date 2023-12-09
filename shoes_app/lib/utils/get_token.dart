import 'package:shared_preferences/shared_preferences.dart';

class GetToken {
  static Future<String?> getToken() async {
    final helper = await SharedPreferences.getInstance();
    final token = helper.getString('token');
    return token;
  }
}
