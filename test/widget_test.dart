import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_app/app.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/auth/data/repository/auth_repository.dart';
import 'package:hr_app/features/auth/logic/auth_cubit.dart';
import 'package:hr_app/features/auth/presentation/views/login_view.dart';

class UnusedAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'unreadable saved token reaches login without wiping local records',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode({
          'id': 42,
          'role': 'manager',
          'job': 'driver',
          'job_type': 'driver',
          'image': '',
          'token': 'old',
        }),
        'is_logged_in': true,
        'push_installation_id': 'keep-this-installation',
      });
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
            (_) async => throw PlatformException(
              code: 'read_failed',
              message: 'Cannot decrypt saved token',
            ),
          );
      addTearDown(() async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel(
                'plugins.it_nomads.com/flutter_secure_storage',
              ),
              null,
            );
        await sl.reset();
      });
      await sl.reset();
      sl.registerFactory<AuthCubit>(() => AuthCubit(UnusedAuthRepository()));
      await UserHelper.initialize();
      expect(UserHelper.isLoggedIn, isFalse);
      expect(UserHelper.currentToken, isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('push_installation_id'), 'keep-this-installation');
      expect(prefs.getString('user_data'), isNotNull);
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.byType(LoginView), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
