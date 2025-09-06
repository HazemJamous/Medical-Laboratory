import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/lab_search_cubit/lab_search_cubit.dart';
import 'package:midical_laboratory/features/pages/auth/login/login_page.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Flutter Local Notifications
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ملف flutterfire (تم إنشاؤه بـ flutterfire configure)
import 'firebase_options.dart';

/// 🟢 إشعارات الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📩 [Background] رسالة جديدة: ${message.messageId}");
}

/// 🔔 Instance عام لـ flutter_local_notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// 🔔 قناة إشعارات Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🟢 تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🟢 إعداد Firebase Messaging للخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🟢 إعداد Flutter Local Notifications
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notification tapped: ${response.payload}");
    },
  );

  // 🟢 طلب صلاحيات الإشعارات
  await FirebaseMessaging.instance.requestPermission();

  // 🟢 جلب الـ FCM Token
  final fcmToken = await FirebaseMessaging.instance.getToken();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? FCMtoken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  sharedPreferences.setString("fcmToken", FCMtoken!);
  print("🔔 FCM Token: $fcmToken");

  // 🟢 استقبال الإشعارات أثناء فتح التطبيق (Foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
          ),
        ),
      );
    }

    print("📩 [Foreground] إشعار: ${notification?.title}");
    print("➡️ البيانات: ${message.data}");
  });

  // 🟢 استقبال الإشعارات عند فتح المستخدم الإشعار
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📲 [فتح الإشعار] البيانات: ${message.data}");
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LabSearchCubit>(create: (_) => LabSearchCubit()),
      ],
      child: const MidicalLaboratoryApp(),
    ),
  );
}

class MidicalLaboratoryApp extends StatelessWidget {
  const MidicalLaboratoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Laboratory',
      theme: ThemeData(
        primaryColor: const Color(0xFF3498DB),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
    );
  }
}
