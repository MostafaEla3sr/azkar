import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notifications/notification_controller.dart';
import 'package:notifications/views/evening_azkar_view.dart';
import 'package:notifications/views/home_view.dart';
import 'package:notifications/views/morning_azkar_view.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:notifications/views/salah_view.dart';
import 'package:notifications/views/sebha_view.dart';
import 'package:notifications/views/splash_view.dart';
import 'generated/l10n.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/notification_model.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(MorningNotificationAdapter());
  Hive.registerAdapter(EveningNotificationAdapter());
  await Hive.openBox<MorningNotification>('morning_notification_box');
  await Hive.openBox<EveningNotification>('evening_notification_box');
  await Hive.openBox('salah_notification_box');
  await Hive.openBox('sebha_box');

  await AwesomeNotifications().initialize(
    null,
    // 'resource://drawable/img',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic Notification',
        channelDescription: 'Basic Notifications Channel',
        importance: NotificationImportance.Max,
        playSound: true,
      ),
      NotificationChannel(
        channelGroupKey: 'alarm_channel_group',
        channelKey: 'alarm_channel',
        channelName: 'Alarm Notification',
        channelDescription: 'Alarm Notifications Channel',
        importance: NotificationImportance.Max,
        playSound: true,
        soundSource: 'resource://raw/salah',
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic Group'),
      NotificationChannelGroup(
          channelGroupKey: 'alarm_channel_group',
          channelGroupName: 'Alarm Group'),
    ],
  );

  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();

  // print(isAllowedToSendNotifications);

  if (!isAllowedToSendNotifications) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: const Locale('ar'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        // brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Cairo',
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Cairo',
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Cairo',
          ),
          bodySmall: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashView.id,
      routes: {
        MorningAzkarView.id: (context) => const MorningAzkarView(),
        HomeView.id: (context) => const HomeView(),
        EveningAzkarView.id: (context) => const EveningAzkarView(),
        SalahView.id: (context) => const SalahView(),
        SebhaView.id: (context) => const SebhaView(),
        SplashView.id: (context) => const SplashView(),
      },
    );
  }
}
