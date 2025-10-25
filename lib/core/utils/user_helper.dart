import 'package:hr_app/core/cache/user_cache.dart';
import 'package:hr_app/features/auth/data/models/response/user_model.dart';

/// Helper class for easy access to user data throughout the app
class UserHelper {
  UserHelper._();

  // Current user data
  static UserModel? _currentUser;
  static String? _currentToken;
  static bool _isLoggedIn = false;

  // Initialize user data
  static Future<void> initialize() async {
    _currentUser = await UserCache.getUser();
    _currentToken = await UserCache.getToken();
    _isLoggedIn = await UserCache.isLoggedIn();
  }

  // Get current user
  static UserModel? get currentUser => _currentUser;

  // Get current token
  static String? get currentToken => _currentToken;

  // Check if user is logged in
  static bool get isLoggedIn => _isLoggedIn;

  // Get user ID
  static int? get userId => _currentUser?.id;

  // Get user role
  static String? get userRole => _currentUser?.role;

  // Get user job
  static String? get userJob => _currentUser?.job;

  // Get user job type
  static String? get userJobType => _currentUser?.jobType;

  // Get user image
  static String? get userImage => _currentUser?.image;

  // Update user data
  static Future<void> updateUser(UserModel user) async {
    _currentUser = user;
    _currentToken = user.token;
    _isLoggedIn = true;
    await UserCache.updateUser(user);
  }

  // Save user data (login)
  static Future<void> saveUser(UserModel user) async {
    print('UserHelper: Saving user data...');
    print('User ID: ${user.id}');
    print('User Role: ${user.role}');
    print('User Job: ${user.job}');
    print('User Token: ${user.token}');

    _currentUser = user;
    _currentToken = user.token;
    _isLoggedIn = true;

    await UserCache.saveUser(user);

    print('UserHelper: User data saved successfully');
    print('Current user: $_currentUser');
    print('Current token: $_currentToken');
    print('Is logged in: $_isLoggedIn');
  }

  // Clear user data (logout)
  static Future<void> clearUser() async {
    _currentUser = null;
    _currentToken = null;
    _isLoggedIn = false;
    await UserCache.clearUser();
  }

  // Refresh user data from cache
  static Future<void> refreshUser() async {
    _currentUser = await UserCache.getUser();
    _currentToken = await UserCache.getToken();
    _isLoggedIn = await UserCache.isLoggedIn();
  }

  // Check if user has specific role
  static bool hasRole(String role) {
    return _currentUser?.role.toLowerCase() == role.toLowerCase();
  }

  // Check if user is manager
  static bool get isManager => hasRole('manager');

  // Check if user is driver
  static bool get isDriver => hasRole('driver');

  // Get user display name
  static String get displayName {
    if (_currentUser == null) return 'مستخدم';
    return '${_currentUser!.role} - ${_currentUser!.job}';
  }

  // Get user info for display
  static Map<String, dynamic> get userInfo {
    if (_currentUser == null) return {};

    return {
      'id': _currentUser!.id,
      'role': _currentUser!.role,
      'job': _currentUser!.job,
      'jobType': _currentUser!.jobType,
      'image': _currentUser!.image,
      'isLoggedIn': _isLoggedIn,
    };
  }
}
