import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:one/Services/noficationservce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:one/Screens/SplashScreen.dart';

Future _fireBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("notification found");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyACXyLdvlHGQssSLxkJe7UUdUaYt7wkOA4",
            appId: "1:680215801181:android:a0538d7ef4e2e35bf98cb4",
            messagingSenderId: "680215801181",
            projectId: "just-8c35a",
            storageBucket: "just-8c35a.appspot.com",
          ),
        )
      : await Firebase.initializeApp();
  await PushNotificationHelper.init();
  await PushNotificationHelper.localNotificationInitialization();
  FirebaseMessaging.onBackgroundMessage(_fireBackgroundMessage);

  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ms', 'MY'),
        Locale('zh', 'CN'),
        Locale('es', 'ES'),
      ],
      path: 'assets/langs', // Path to your JSON files
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();

  // Function to set theme
  static void setTheme(BuildContext context, ThemeData theme, ThemeMode mode) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setTheme(theme, mode);
  }
}

class _MyAppState extends State<MyApp> {
  ThemeData _themeData = ThemeData.light();
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadDarkModeSetting();
  }

  // Load dark mode setting from shared preferences
  Future<void> _loadDarkModeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('darkMode') ?? false;
    setState(() {
      _themeData = isDarkMode ? ThemeData.dark() : ThemeData.light();
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Set theme method
  void setTheme(ThemeData theme, ThemeMode mode) {
    setState(() {
      _themeData = theme;
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: _themeData,
      themeMode: _themeMode,
      darkTheme: ThemeData.dark(),
      home: const SplashScreen(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
