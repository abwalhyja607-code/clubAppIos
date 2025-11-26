
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTokenOrganization(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token admin', token);
}


Future<String?> getTokenOrganization() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token admin');
}

Future<void> deleteTokenOrganization() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token admin');
}





Future<void> saveRoleOrganization(String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('role', role);
}


Future<String?> getRoleOrganization() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('role');
}

Future<void> deleteRoleOrganization() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('role');
}


