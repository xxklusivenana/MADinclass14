import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

// Handles messages received while the app is in the background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase before processing the background message.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Print message information for debugging and testing
  debugPrint('Background message received: ${message.messageId}');
  debugPrint('Background data: ${message.data}');
}

// Manages Firebase Cloud Messaging and notification processing
class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Requests notification permission and registers message handlers
  Future<void> initialize({
    required Function(String asset, String title) onMessageReceived,
  }) async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Receives messages while the app is open and in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received');

      _processMessage(message, onMessageReceived);
    });

    // Handles notification taps when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Background notification opened');

      _processMessage(message, onMessageReceived);
    });

    RemoteMessage? initialMessage =
        await _messaging.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('App opened from terminated state');

      _processMessage(initialMessage, onMessageReceived);
    }
  }

  // Checks notification data before allowing  UI to update
  void _processMessage(
    RemoteMessage message,
    Function(String asset, String title) onMessageReceived,
  ) {
    // Get the custom data fields sent with the notification
    final Map<String, dynamic> data = message.data;

    final String? asset = data['asset'];
    final String? action = data['action'];

    // Make sure the notification requests a supported action
    if (action != 'update_ui') {
      debugPrint('Invalid notification action: $action');
      return;
    }

    // Only allow the two images included in the application.
    // Unknown image names are rejected to prevent invalid asset paths.
    if (asset != 'default' && asset != 'promo') {
      debugPrint('Invalid notification asset: $asset');
      return;
    }

    // Use the notification title or a default title if one is missing.
    final String title =
        message.notification?.title ?? 'Notification received';

    // Send the validated values to the screen.
    onMessageReceived(asset!, title);
  }

  // Gets the device's FCM token for sending test notifications.
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}

// Application entry point.
Future<void> main() async {
  // Make sure Flutter is initialized before using Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Connect the application to the Firebase project.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register the background handler before runApp().
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // Start the Flutter application.
  runApp(const MyApp());
}

// Builds the main application and applies its theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inclass14: Firebase Cloud Activity',
      theme: ThemeData(
        // Sets the application's main color.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 62, 180, 90),
        ),
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}

// Displays notification information and the selected image
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FCMService _fcmService = FCMService();

  String _currentAsset = 'default';
  String _notificationTitle = 'Waiting for notifications...';
  String _status = 'Ready';

  @override
  void initState() {
    super.initState();

    // Initialize Firebase Messaging when the screen is created
    _initializeFCM();
  }

  // Sets up notification handling and retrieves the device token
  Future<void> _initializeFCM() async {
    await _fcmService.initialize(
      onMessageReceived: (asset, title) {
        // Make sure the screen still exists before updating
        if (!mounted) return;

        // Update the displayed information using the received data
        setState(() {
          _currentAsset = asset;
          _notificationTitle = title;
          _status = 'Notification processed successfully';
        });
      },
    );

    final token = await _fcmService.getToken();

    debugPrint('FCM Device Token: $token');

    // Update the status after Firebase Messaging is initialized
    if (mounted) {
      setState(() {
        _status = 'Firebase Messaging initialized';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Select the image based on the validated notification asset
    final String imagePath = _currentAsset == 'promo'
        ? 'assets/promo.png'
        : 'assets/default.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Cloud Messaging'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _notificationTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Image.asset(
                imagePath,
                height: 220,
                width: 220,
                fit: BoxFit.contain,

                // fallback icon
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 100,
                  );
                },
              ),

              const SizedBox(height: 20),

              // Shows which image is currently selected
              Text(
                'Current asset: $_currentAsset',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              // Displays the current Firebase/application status
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green),
              ),

              const SizedBox(height: 25),

              // Allows the user to manually return to default screen
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentAsset = 'default';
                    _notificationTitle = 'Default screen';
                    _status = 'Screen reset manually';
                  });
                },
                child: const Text('Reset Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}