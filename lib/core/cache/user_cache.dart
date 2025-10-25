import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_app/core/cache/secure_storage.dart';
import 'package:hr_app/features/auth/data/models/response/user_model.dart';

class UserCache {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'user_token';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save user data
  static Future<void> saveUser(UserModel user) async {
    print('UserCache: Saving user data...');
    print('User JSON: ${jsonEncode(user.toJson())}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    print('UserCache: User data saved to SharedPreferences');

    // Save token in secure storage
    await SecureStorage.write(_tokenKey, user.token);
    print('UserCache: Token saved to SecureStorage');

    await prefs.setBool(_isLoggedInKey, true);
    print('UserCache: Login status set to true');
  }

  // Get user data
  static Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Get user token
  static Future<String?> getToken() async {
    return await SecureStorage.read(_tokenKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Update user data
  static Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  // Clear user data (logout)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    // Clear token from secure storage
    await SecureStorage.delete(_tokenKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Get user ID
  static Future<int?> getUserId() async {
    final user = await getUser();
    return user?.id;
  }

  // Get user role
  static Future<String?> getUserRole() async {
    final user = await getUser();
    return user?.role;
  }

  // Get user job
  static Future<String?> getUserJob() async {
    final user = await getUser();
    return user?.job;
  }

  // Get user image
  static Future<String?> getUserImage() async {
    final user = await getUser();
    return user?.image;
  }
}
