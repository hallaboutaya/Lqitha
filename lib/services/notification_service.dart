import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../core/logging/app_logger.dart';
import '../data/repositories/user_repository.dart';
import '../services/service_locator.dart';
import '../services/auth_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool _isInitialized = false;

  /// Initialize Firebase and FCM settings.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Skip FCM initialization on web platform - requires different setup
      if (kIsWeb) {
        AppLogger.i('🔔 Skipping FCM initialization on web (not supported yet)');
        _isInitialized = true;
        return;
      }

      AppLogger.i('🔔 Initializing NotificationService...');
      
      // Initialize Firebase
      await Firebase.initializeApp();

      // Request permissions (especially for iOS)
      await _requestPermissions();

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AppLogger.i('📩 Foreground message received: ${message.notification?.title}');
      });

      // Handle message opening when app is in background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        AppLogger.i('📬 App opened via notification: ${message.notification?.title}');
      });

      _isInitialized = true;
      AppLogger.i('✅ NotificationService initialized.');
      
      // Try to register token if user is already logged in
      await registerToken();
      
    } catch (e, stackTrace) {
      AppLogger.w('⚠️ FCM initialization failed (this is normal on web): $e');
      _isInitialized = true; // Mark as initialized to prevent retry loops
    }
  }

  /// Request notification permissions.
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppLogger.i('✅ User granted notification permissions.');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      AppLogger.i('✅ User granted provisional notification permissions.');
    } else {
      AppLogger.w('⚠️ User declined or has not accepted notification permissions.');
    }
  }

  /// Get FCM token and register it with the backend.
  Future<void> registerToken() async {
    try {
      // Skip on web
      if (kIsWeb) {
        AppLogger.d('ℹ️ Skipping FCM token registration on web');
        return;
      }

      final authService = getIt<AuthService>();
      if (!authService.isLoggedIn) {
        AppLogger.d('ℹ️ User not logged in, skipping FCM token registration.');
        return;
      }

      String? token;
      if (Platform.isIOS) {
        token = await _fcm.getAPNSToken();
      }
      
      // Default to standard FCM token
      token = await _fcm.getToken();

      if (token != null) {
        AppLogger.i('🔑 FCM Token obtained: $token');
        final userRepository = getIt<UserRepository>();
        await userRepository.updateFCMToken(authService.currentUserId, token);
        AppLogger.i('✅ FCM Token registered with backend.');
      } else {
        AppLogger.w('⚠️ Failed to obtain FCM token.');
      }
    } catch (e, stackTrace) {
      AppLogger.w('⚠️ Error registering FCM token: $e');
    }
  }
}

/// Top-level background message handler.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background work
  await Firebase.initializeApp();
  print("🛠️ Handling a background message: ${message.messageId}");
}
