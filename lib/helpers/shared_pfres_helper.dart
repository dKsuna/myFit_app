import 'package:shared_preferences/shared_preferences.dart';

Future<void> completeRegistration(String userName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isRegistered', true);
  await prefs.setString('userName', userName);
}
