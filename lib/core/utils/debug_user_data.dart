import 'package:hr_app/core/cache/user_cache.dart';
import 'package:hr_app/core/utils/user_helper.dart';

/// Debug helper to check saved user data
class DebugUserData {
  /// Check if user data is saved correctly
  static Future<void> checkSavedUserData() async {
    print('=== DEBUG: Checking Saved User Data ===');

    // Check UserHelper
    print('UserHelper.isLoggedIn: ${UserHelper.isLoggedIn}');
    print('UserHelper.currentUser: ${UserHelper.currentUser}');
    print('UserHelper.currentToken: ${UserHelper.currentToken}');
    print('UserHelper.userId: ${UserHelper.userId}');
    print('UserHelper.userRole: ${UserHelper.userRole}');
    print('UserHelper.userJob: ${UserHelper.userJob}');
    print('UserHelper.userImage: ${UserHelper.userImage}');

    // Check UserCache
    print('\n--- UserCache Data ---');
    final cachedUser = await UserCache.getUser();
    print('Cached User: $cachedUser');

    final cachedToken = await UserCache.getToken();
    print('Cached Token: $cachedToken');

    final isLoggedIn = await UserCache.isLoggedIn();
    print('Cached isLoggedIn: $isLoggedIn');

    // Check user info
    print('\n--- User Info ---');
    print('User Info: ${UserHelper.userInfo}');

    print('=== END DEBUG ===');
  }

  /// Test reading user data after login
  static Future<void> testUserDataAfterLogin() async {
    print('=== Testing User Data After Login ===');

    // Refresh user data
    await UserHelper.refreshUser();

    // Check if data is available
    if (UserHelper.isLoggedIn) {
      print('✅ User is logged in');
      print('User ID: ${UserHelper.userId}');
      print('User Role: ${UserHelper.userRole}');
      print('User Job: ${UserHelper.userJob}');
      print('User Image: ${UserHelper.userImage}');
      print('Display Name: ${UserHelper.displayName}');
    } else {
      print('❌ User is not logged in');
    }

    print('=== END TEST ===');
  }
}
