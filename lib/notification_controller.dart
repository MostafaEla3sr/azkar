import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notifications/views/morning_azkar_view.dart';

import 'main.dart';

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {


    if (receivedAction.channelKey == 'basic_channel') {
      // Check the action to determine which button was clicked (if you have multiple actions)
      if (receivedAction.id == 'your_action_id') {
        // Navigate to MorningAzkarView
        _navigateToMorningAzkarView();
      }
    }


      // if (navigatorKey.currentState != null) {
      //   navigatorKey.currentState!.pushReplacement(
      //     PageRouteBuilder(
      //       pageBuilder: (context, animation1, animation2) =>
      //           MorningAzkarView(), // Replace 'DesiredPage' with the actual page you want to navigate to
      //       transitionDuration: const Duration(milliseconds: 0),
      //     ),
      //   );
      // }




    // // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //     '/notification-page',
    //     (route) =>
    //         (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
  static void _navigateToMorningAzkarView() {
    runApp(
      MaterialApp(
        home: MorningAzkarView(),
      ),
    );
  }
}
