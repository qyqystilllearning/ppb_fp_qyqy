import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await DatabaseService.initialize();

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    null, // Default app icon
    [
      NotificationChannel(
        channelKey: 'task_reminders',
        channelName: 'Task Reminders',
        channelDescription: 'Notification channel for task deadlines',
        defaultColor: AppTheme.primaryColor,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
  );

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
  );

  runApp(const MyApp());
}

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    debugPrint('🔔 BACKEND LOG: Notification successfully SCHEDULED/CREATED: ${receivedNotification.title}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    debugPrint('✅ BACKEND LOG: Notification physically DISPLAYED on screen: ${receivedNotification.title}');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint('👆 BACKEND LOG: User TAPPED the notification: ${receivedAction.title}');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // We expose a static method to allow switching themes globally!
  static void switchTheme(BuildContext context, bool isDarkMode) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeTheme(isDarkMode);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Bonus Feature: Dark/Light Mode
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void changeTheme(bool dark) {
    setState(() {
      isDarkMode = dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}