import 'package:hr_app/core/utils/user_helper.dart';

/// Example usage of UserHelper throughout the app
class UserUsageExample {
  // Example 1: Check if user is logged in
  static void checkLoginStatus() {
    if (UserHelper.isLoggedIn) {
      print('User is logged in');
      print('User ID: ${UserHelper.userId}');
      print('User Role: ${UserHelper.userRole}');
    } else {
      print('User is not logged in');
    }
  }

  // Example 2: Get user information
  static void displayUserInfo() {
    final user = UserHelper.currentUser;
    if (user != null) {
      print('User Info:');
      print('ID: ${user.id}');
      print('Role: ${user.role}');
      print('Job: ${user.job}');
      print('Job Type: ${user.jobType}');
      print('Image: ${user.image}');
    }
  }

  // Example 3: Check user role
  static void checkUserRole() {
    if (UserHelper.isManager) {
      print('User is a Manager');
    } else if (UserHelper.isDriver) {
      print('User is a Driver');
    } else {
      print('User has other role: ${UserHelper.userRole}');
    }
  }

  // Example 4: Get user display name
  static void showUserDisplayName() {
    print('Welcome ${UserHelper.displayName}');
  }

  // Example 5: Get user info map
  static Map<String, dynamic> getUserInfoMap() {
    return UserHelper.userInfo;
  }

  // Example 6: Update user data
  static Future<void> updateUserData() async {
    // This would typically be called when user data changes
    await UserHelper.refreshUser();
  }

  // Example 7: Logout user
  static Future<void> logoutUser() async {
    await UserHelper.clearUser();
    print('User logged out successfully');
  }
}

/// Usage in widgets:
///
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         if (UserHelper.isLoggedIn) ...[
///           Text('Welcome ${UserHelper.displayName}'),
///           Text('Role: ${UserHelper.userRole}'),
///           if (UserHelper.isManager)
///             ElevatedButton(
///               onPressed: () => print('Manager actions'),
///               child: Text('Manager Panel'),
///             ),
///         ] else ...[
///           Text('Please login'),
///         ],
///       ],
///     );
///   }
/// }
/// ```
