import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../firebase_options.dart';
import '../Router/app_router.dart';
import '../locator/service_locator.dart';
import '../network/network_config.dart';
import '../utils/user_helper.dart';
import '../../features/auth/router/auth_names.dart';
import '../../features/notifications/logic/notifications_cubit.dart';
import '../../features/account/router/account_route_extra.dart';
import '../../features/account/data/models/employee_request_type.dart';
import 'push_route.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Notification payloads are displayed by the OS; never display a duplicate.
}

class PushService with WidgetsBindingObserver {
  PushService._();
  static final instance = PushService._();
  final _local = FlutterLocalNotificationsPlugin();
  final _shown = <String>{}, _opened = <String>{};
  Future<void>? _initializing;
  Future<void> _serial = Future.value();
  Timer? _retry;
  Timer? _initializationRetry;
  int _initializationAttempts = 0;
  int _epoch = 0, _attempt = 0;
  String? _session;
  String? _registeredToken, _registeredSession;
  bool _expiring = false;
  bool _ready = false, _homeReady = false, _registrationQueued = false;
  Map<String, dynamic>? _pending;
  String? _pendingTitle, _pendingBody;
  late SharedPreferences _prefs;
  bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<String> installationId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('push_installation_id');
    if (id == null) {
      id = const Uuid().v4();
      await prefs.setString('push_installation_id', id);
    }
    return id;
  }

  Future<void> initialize() async {
    if (!supported) return;
    try {
      await (_initializing ??= _initialize());
    } catch (_) {
      _initializing = null;
      debugPrint('Push initialization unavailable; Home remains usable.');
    }
  }

  Future<void> _initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
    _prefs = await SharedPreferences.getInstance();
    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onDidReceiveNotificationResponse: (response) {
        try {
          final value =
              jsonDecode(response.payload ?? '{}') as Map<String, dynamic>;
          open(
            value['data'] as Map<String, dynamic>,
            title: value['title'] as String?,
            body: value['body'] as String?,
          );
        } catch (_) {
          /* Ignore malformed/stale local payloads. */
        }
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'hr_notifications',
            'إشعارات الموارد البشرية',
            description: 'إشعارات وطلبات الموظفين',
            importance: Importance.high,
          ),
        );
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    final localInitial = await _local.getNotificationAppLaunchDetails();
    if (initial != null) {
      _pending = initial.data;
      _pendingTitle = initial.notification?.title;
      _pendingBody = initial.notification?.body;
    }
    if (localInitial?.didNotificationLaunchApp == true) {
      try {
        final value =
            jsonDecode(localInitial!.notificationResponse!.payload!)
                as Map<String, dynamic>;
        _pending = value['data'];
        _pendingTitle = value['title'];
        _pendingBody = value['body'];
      } catch (_) {
        /* Malformed payload. */
      }
    }
    FirebaseMessaging.onMessage.listen(
      (message) => unawaited(_foreground(message)),
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => open(
        message.data,
        title: message.notification?.title,
        body: message.notification?.body,
      ),
    );
    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      _attempt = 0;
      _scheduleRegistration();
    });
    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        _attempt = 0;
        _scheduleRegistration();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    _ready = true;
  }

  Future<void> authenticatedHome() async {
    if (!UserHelper.isLoggedIn || UserHelper.currentToken == null) return;
    _homeReady = true;
    refreshInbox();
    await initialize();
    if (!UserHelper.isLoggedIn) return;
    if (!_ready) {
      if (supported && _initializationAttempts < 4) {
        _initializationRetry?.cancel();
        _initializationRetry = Timer(
          Duration(seconds: 2 << _initializationAttempts++),
          () => unawaited(authenticatedHome()),
        );
      }
      return;
    }
    _initializationAttempts = 0;
    _initializationRetry?.cancel();
    if (_session != UserHelper.currentToken) {
      _epoch++;
      _attempt = 0;
      _session = UserHelper.currentToken;
      _shown.clear();
      _opened.clear();
      sl<NotificationsCubit>().resetSession();
      _scheduleRegistration();
    }
    refreshInbox();
    final pending = _pending;
    _pending = null;
    if (pending != null) {
      open(pending, title: _pendingTitle, body: _pendingBody);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && UserHelper.isLoggedIn) {
      refreshInbox();
      _attempt = 0;
      _scheduleRegistration();
    }
  }

  void refreshInbox() {
    if (UserHelper.isLoggedIn) {
      unawaited(sl<NotificationsCubit>().getNotifications());
    }
  }

  bool _current(int epoch, String token) =>
      epoch == _epoch &&
      _session == token &&
      UserHelper.currentToken == token &&
      UserHelper.isLoggedIn;
  Dio _client(String token) => Dio(
    BaseOptions(
      baseUrl: sl<NetworkConfig>().baseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      sendTimeout: const Duration(seconds: 12),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  void _scheduleRegistration() {
    if (!_ready || _session == null || _registrationQueued) return;
    _retry?.cancel();
    final epoch = _epoch, token = _session!;
    _registrationQueued = true;
    _serial = _serial
        .then((_) async {
          try {
            if (_current(epoch, token)) await _register(epoch, token);
          } finally {
            _registrationQueued = false;
          }
        })
        .catchError((Object _) {
          _registrationQueued = false;
        });
  }

  Future<void> _register(int epoch, String session) async {
    try {
      final permission = await FirebaseMessaging.instance.requestPermission();
      if (!_current(epoch, session) ||
          permission.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }
      final token = await FirebaseMessaging.instance.getToken().timeout(
        const Duration(seconds: 12),
      );
      if (token == null || token.isEmpty) throw StateError('Token not ready');
      final id = await installationId();
      if (!_current(epoch, session)) return;
      // A failed topic subscription retries independently of backend registration.
      var topic = _prefs.getString('push_topic');
      if (_registeredToken != token ||
          _registeredSession != session ||
          topic == null) {
        final response = await _client(session).post(
          '/employee/fcm-token',
          data: {'device_id': id, 'fcm_token': token, 'platform': 'android'},
        );
        if (!_current(epoch, session)) return;
        if (response.data['key'] != 'success') {
          throw StateError('Registration rejected');
        }
        topic = response.data['data']['topic'] as String;
        _registeredToken = token;
        _registeredSession = session;
      }
      final old = _prefs.getString('push_topic');
      if (old != null && old != topic) {
        await FirebaseMessaging.instance
            .unsubscribeFromTopic(old)
            .timeout(const Duration(seconds: 12));
      }
      await _prefs.setString('push_topic', topic);
      await _prefs.setString('push_owner', UserHelper.userId.toString());
      if (!_current(epoch, session)) return;
      await FirebaseMessaging.instance
          .subscribeToTopic(topic)
          .timeout(const Duration(seconds: 12));
      _attempt = 0;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 && _current(epoch, session)) {
        unawaited(expireSession(session));
      } else if (error.response == null ||
          error.response!.statusCode! >= 500 ||
          error.response!.statusCode == 429) {
        _backoff(epoch, session);
      }
    } catch (_) {
      _backoff(epoch, session);
    }
  }

  void _backoff(int epoch, String session) {
    if (!_current(epoch, session) || _attempt >= 4) return;
    final delay = Duration(seconds: 2 << _attempt++);
    _retry = Timer(delay, _scheduleRegistration);
  }

  Future<void> expireSession(String expectedSession) async {
    if (_expiring || UserHelper.currentToken != expectedSession) return;
    _expiring = true;
    try {
      await endSession(removeFromBackend: false);
      if (UserHelper.currentToken != expectedSession) return;
      await UserHelper.clearUser();
      AppRouter.router.go(AuthRoutes.login);
    } finally {
      _expiring = false;
    }
  }

  /// Invalidates callbacks immediately, then drains registration before removal.
  Future<void> endSession({bool removeFromBackend = true}) async {
    final session = UserHelper.currentToken;
    _epoch++;
    _session = null;
    _homeReady = false;
    _pending = null;
    _registeredToken = null;
    _registeredSession = null;
    _retry?.cancel();
    _initializationRetry?.cancel();
    _shown.clear();
    _opened.clear();
    sl<NotificationsCubit>().resetSession();
    await _serial;
    if (!supported) return;
    final prefs = await SharedPreferences.getInstance();
    final topic = prefs.getString('push_topic');
    try {
      if (topic != null) {
        await FirebaseMessaging.instance
            .unsubscribeFromTopic(topic)
            .timeout(const Duration(seconds: 8));
      }
    } catch (_) {}
    try {
      if (removeFromBackend && session != null) {
        await _client(session).delete(
          '/employee/fcm-token',
          data: {'device_id': await installationId()},
        );
      }
    } catch (_) {}
    try {
      await FirebaseMessaging.instance.deleteToken().timeout(
        const Duration(seconds: 8),
      );
    } catch (_) {}
    try {
      await _local.cancelAll();
    } catch (_) {}
    await prefs.remove('push_topic');
    await prefs.remove('push_owner');
  }

  Future<void> _foreground(RemoteMessage message) async {
    if (!UserHelper.isLoggedIn || _session != UserHelper.currentToken) return;
    refreshInbox(); // Always refresh, including duplicate delivery.
    if (pushDestination(
          message.data,
          userId: UserHelper.userId,
          manager: UserHelper.isManager,
        ) ==
        null) {
      return;
    }
    final id = pushIdentity(message.data) ?? message.messageId;
    if (id != null && !_remember(_shown, id)) return;
    if (message.notification == null) return;
    try {
      await _local.show(
        (id ?? DateTime.now().toIso8601String()).hashCode & 0x7fffffff,
        message.notification?.title,
        message.notification?.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'hr_notifications',
            'إشعارات الموارد البشرية',
            icon: 'ic_notification',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: jsonEncode({
          'data': message.data,
          'title': message.notification?.title,
          'body': message.notification?.body,
        }),
      );
    } catch (_) {
      debugPrint('Foreground notification unavailable.');
    }
  }

  bool _remember(Set<String> cache, String id) {
    if (!cache.add(id)) return false;
    if (cache.length > 100) cache.remove(cache.first);
    return true;
  }

  void open(
    Map<String, dynamic> data, {
    String? title,
    String? body,
    bool deduplicate = true,
  }) {
    if (!_homeReady) {
      _pending = data;
      _pendingTitle = title;
      _pendingBody = body;
      return;
    }
    final destination = pushDestination(
      data,
      userId: UserHelper.userId,
      manager: UserHelper.isManager,
    );
    if (destination == null || !UserHelper.isLoggedIn) return;
    final id = pushIdentity(data);
    if (deduplicate && id != null && !_remember(_opened, id)) return;
    refreshInbox();
    if (data['type'] == 'announcement') {
      final context = AppRouter
          .router
          .routerDelegate
          .navigatorKey
          .currentState
          ?.overlay
          ?.context;
      if (context != null) {
        unawaited(
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(title ?? 'إعلان'),
              content: Text(body ?? ''),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق'),
                ),
              ],
            ),
          ),
        );
      }
      return;
    }
    final notificationId = data['notification_id']?.toString();
    if (notificationId != null && notificationId.isNotEmpty) {
      unawaited(sl<NotificationsCubit>().markAsRead(notificationId));
    }
    final requestId = int.tryParse(data['request_id']?.toString() ?? '');
    if (data['type'] == 'new_employee_request' &&
        UserHelper.isManager &&
        requestId != null &&
        requestId > 0 &&
        ['leave', 'advance'].contains(data['request_type'])) {
      AppRouter.router.push(
        '/account/employee-request-details',
        extra: EmployeeRequestDetailsExtra(
          requestId: requestId,
          requestType: data['request_type'] == 'leave'
              ? EmployeeRequestType.vacation
              : EmployeeRequestType.normalAdvance,
        ),
      );
    } else {
      AppRouter.router.push(destination);
    }
  }
}
