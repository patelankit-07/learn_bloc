import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _username;
  String? _password;
  String? _email;
  String? _phone;
  String? _address;

  // Getters for the fields
  String? get username => _username;
  String? get password => _password;
  String? get email => _email;
  String? get phone => _phone;
  String? get address => _address;

  // Method to register a user with additional details
  Future<void> registerUser({
    required String username,
    required String password,
    required String email,
    required String phone,
    required String address,
  }) async {
    _username = username;
    _password = password;
    _email = email;
    _phone = phone;
    _address = address;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    notifyListeners();
  }

  // Method to load user details from SharedPreferences
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _password = prefs.getString('password');
    _email = prefs.getString('email');
    _phone = prefs.getString('phone');
    _address = prefs.getString('address');
    notifyListeners();
  }

  // Method to log in a user by validating the username and password
  Future<bool> loginUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');

    if (storedUsername == username && storedPassword == password) {
      _username = username;
      _password = password;
      _email = prefs.getString('email');
      _phone = prefs.getString('phone');
      _address = prefs.getString('address');
      notifyListeners();
      return true;
    }
    return false;
  }
}
