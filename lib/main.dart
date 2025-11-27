import 'package:club_app_organizations_section/appScreenOrganizations/notification/notificationScreen.dart';
import 'package:club_app_organizations_section/saveToken/saveToken.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'appScreenOrganizations/loginScren/loginScreen.dart';
import 'appScreenOrganizations/notification/notification.dart';
import 'appScreenOrganizations/sectionsScreen/sectionsScreen.dart';
import 'bloc/Cubit.dart';
import 'bloc/states.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // الخطوة 1: تهيئة Firebase قبل أي شيء آخر
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    print("Firebase init error: $e");
    // لا تستخدم Crashlytics هنا قبل التهيئة
  }

  // الخطوة 2: تهيئة Crashlytics بعد Firebase
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // الخطوة 3: تشغيل Notifications بعد Firebase
  final firebaseNotification = FirebaseNotification();
  try {
    await firebaseNotification.initNotifications();
  } catch (e, st) {
    print('Notification init error: $e');
    FirebaseCrashlytics.instance.recordError(e, st);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // الخطوة 4: تشغيل التطبيق بعد كل التهيئات
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _token;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    // أي كود يعتمد Firebase يجب أن يكون بعد initializeApp
    String? token = await getTokenOrganization();
    setState(() {
      _token = token;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CubitApp()..checkTokenData(),
      child: BlocConsumer<CubitApp, StatesApp>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = CubitApp.get(context);

          return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (_, __) => MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              locale: const Locale('ar'),
              routes: {
                NotificationScreen.routeName: (_) => NotificationScreen(),
              },
              home: _loading
                  ? const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
                  : _token == null
                  ? LoginScreen()
                  : cubit.dataCheckToken
                  ? SectionScreen()
                  : LoginScreen(),
            ),
          );
        },
      ),
    );
  }
}
