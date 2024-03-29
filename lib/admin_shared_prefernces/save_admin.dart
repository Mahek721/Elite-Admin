import 'package:shared_preferences/shared_preferences.dart';

class SaveAdmin {
  Future<void> CreateAdmin(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentAdmin', email);
  }

  Future<void> RemoveAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentAdmin', "");
  }

  dynamic CurrentAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('CurrentAdmin') ?? '';
    return email;
  }
}