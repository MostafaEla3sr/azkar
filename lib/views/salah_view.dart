import 'package:adhan/adhan.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:notifications/colors.dart';

class SalahView extends StatefulWidget {
  const SalahView({Key? key}) : super(key: key);

  static const String id = 'SalahView';

  @override
  State<SalahView> createState() => _SalahViewState();
}

class _SalahViewState extends State<SalahView> {
  bool isSwitched = false;
  List<int> notificationIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background.jpg',
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          fit: BoxFit.cover,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            buildSwitchListTile(),
            const SizedBox(
              height: 200,
            ),
            const Text(
              'مواقيت الصلاة',
              style: TextStyle(
                  color: MyColors.azkarColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(child: buildPrayerTimesListView()),
          ],
        ),
      ],
    ));
  }

  ValueListenableBuilder<Box> buildSwitchListTile() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('salah_notification_box').listenable(),
      builder: (context, box, child) {
        var isAllowed = box.get('isAllowed', defaultValue: false);
        return SwitchListTile(
          title: const Text(
            'تفعيل الاشعارات',
            style: TextStyle(
              color: MyColors.azkarColor,
              fontSize: 18,
            ),
          ),
          value: isAllowed,
          activeTrackColor: MyColors.azkarColor,
          activeColor: const Color(0xff1D1A1B),
          inactiveTrackColor: Colors.white,
          // inactiveThumbColor:Color(0xffF5D49B) ,

          onChanged: (value) {
            box.put('isAllowed', value);

            setState(() {

              isAllowed = value;
              isAllowed
                  ? schedulePrayerTimeNotifications()
                  : cancelPrayerTimeNotifications();
            });
          },
        );
      },
    );
  }

  ListView buildPrayerTimesListView() {
    final myCoordinates = Coordinates(30.597246, 30.987632);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    List<String> prayerTimesList = [
      DateFormat.jm().format(prayerTimes.fajr),
      DateFormat.jm().format(prayerTimes.sunrise),
      DateFormat.jm().format(prayerTimes.dhuhr),
      DateFormat.jm().format(prayerTimes.asr),
      DateFormat.jm().format(prayerTimes.maghrib),
      DateFormat.jm().format(prayerTimes.isha),
    ];

    List<String> prayerIconList = [
      'assets/icons/fajr.png',
      'assets/icons/sunrise.png',
      'assets/icons/dhuhr.png',
      'assets/icons/asr.png',
      'assets/icons/maghrib.png',
      'assets/icons/isha.png',
    ];

    return ListView.builder(
      itemCount: prayerTimesList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            decoration: const BoxDecoration(
              color: MyColors.azkarColor,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Image.asset(prayerIconList[index]),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${getPrayerName(index)} : ',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                        // color: Color(0xffFBE6C5),
                        ),
                  ),
                  const Spacer(),
                  Text(
                    prayerTimesList[index],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // child: ListTile(
          //   title: Text(
          //     getPrayerName(index),
          //     style: const TextStyle(fontSize: 24),
          //   ),
          //   subtitle: Text(
          //     'الوقت : ${prayerTimesList[index]}',
          //     // Replace with the actual time
          //     style: const TextStyle(fontSize: 18),
          //   ),
          // ),
        );
      },
    );
  }

  void schedulePrayerTimeNotification(int index, String prayerTime) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: index + 1,
        channelKey: 'alarm_channel',
        title: 'مواقيت الصلاه',
        body: 'حان الان موعد صلاة ${getPrayerName(index)}',
      ),
      schedule: NotificationCalendar(
        timeZone: localTimeZone,
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day,
        hour: getHour(prayerTime),
        minute: getMinute(prayerTime),
        second: 0,
        allowWhileIdle: true,
        repeats: true,
      ),
    );

    debugPrint(localTimeZone);
    debugPrint(DateTime.now().year.toString());
    debugPrint(DateTime.now().month.toString());
    debugPrint(DateTime.now().day.toString());
    debugPrint(getHour(prayerTime).toString());
    debugPrint(getMinute(prayerTime).toString());
  }

  void schedulePrayerTimeNotifications() {
    final myCoordinates = Coordinates(30.597246, 30.987632);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    List<String> prayerTimesList = [
      DateFormat.jm().format(prayerTimes.fajr),
      DateFormat.jm().format(prayerTimes.sunrise),
      DateFormat.jm().format(prayerTimes.dhuhr),
      DateFormat.jm().format(prayerTimes.asr),
      DateFormat.jm().format(prayerTimes.maghrib),
      DateFormat.jm().format(prayerTimes.isha),
    ];

    for (int i = 0; i < prayerTimesList.length; i++) {
      schedulePrayerTimeNotification(i, prayerTimesList[i]);
      notificationIds.add(i + 1);
    }
  }

  void cancelPrayerTimeNotifications() {
    for (int id in notificationIds) {
      AwesomeNotifications().cancelSchedule(id);
    }
    notificationIds.clear();
  }

  String getPrayerName(int index) {
    switch (index) {
      case 0:
        return 'الفجر';
      case 1:
        return 'الصبح';
      case 2:
        return 'الظهر';
      case 3:
        return 'العصر';
      case 4:
        return 'المغرب';
      case 5:
        return 'العشاء';
      default:
        return '';
    }
  }

  int getHour(String time) {
    try {
      String cleanedTime = replaceArabicNumerals(time);

      // Extract the hour part
      int hour = int.parse(cleanedTime.split(':')[0]);

      // If PM, add 12 to the hour
      if (cleanedTime.toLowerCase().contains('pm')) {
        hour += 12;
      }

      return hour;
    } catch (e) {
      debugPrint('Error parsing hour: $e');
      return 0;
    }
  }

  int getMinute(String time) {
    try {
      String cleanedTime = replaceArabicNumerals(time);

      // Extract the minutes part
      int minutes =
          int.parse(cleanedTime.split(':')[1].replaceAll(RegExp('[^0-9]'), ''));

      return minutes;
    } catch (e) {
      debugPrint('Error parsing minute: $e');
      return 0;
    }
  }

  String replaceArabicNumerals(String input) {
    // Map Arabic numerals to standard numerals
    Map<String, String> arabicToStandard = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      'ص': 'AM',
      'م': 'PM',
    };

    // Replace Arabic numerals in the input string
    String cleanedInput = input;
    arabicToStandard.forEach((arabic, standard) {
      cleanedInput = cleanedInput.replaceAll(arabic, standard);
    });

    return cleanedInput;
  }
}
