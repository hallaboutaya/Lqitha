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
      AppLogger.i('🔔 Initializing NotificationService...');
      
      // Initialize Firebase (if not already initialized via DefaultFirebaseOptions)
      // Note: Assuming google-services.json and GoogleService-Info.plist are correctly placed
      await Firebase.initializeApp();

      // Request permissions (especially for iOS)
      await _requestPermissions();

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AppLogger.i('📩 Foreground message received: ${message.notification?.title}');
        // You can show a local notification here if needed
        // For now, we'll just log it. The UI can also listen to a stream.
      });

      // Handle message opening when app is in background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        AppLogger.i('📬 App opened via notification: ${message.notification?.title}');
        // Navigate to specifically the notifications page or related post
      });

      _isInitialized = true;
      AppLogger.i('✅ NotificationService initialized.');
      
      // Try to register token if user is already logged in
      await registerToken();
      
    } catch (e, stackTrace) {
      AppLogger.e('❌ Failed to initialize NotificationService', e, stackTrace);
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
      final authService = getIt<AuthService>();
      if (!authService.isLoggedIn) {
        AppLogger.d('ℹ️ User not logged in, skipping FCM token registration.');
        return;
      }

      String? token;
      if (kIsWeb) {
        // Handle web FCM if needed
      } else if (Platform.isIOS) {
        token = await _fcm.getAPNSToken();
      }
      
      // Default to standard FCM token
      token = await _fcm.getToken();

      if (token != null) {
        AppLogger.i('🔑 FCM Token obtained: $token');
        final userRepository = getIt<UserRepository>();
        await userRepository.updateFCMToken(authService.currentUserId, token);
        AppLogger.i('✅ FCM Token registered with backend.');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error registering FCM token', e, stackTrace);
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
