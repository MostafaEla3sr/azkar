import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notifications/models/notification_model.dart';

import '../colors.dart';

class EveningAzkarView extends StatefulWidget {
  const EveningAzkarView({super.key});

  static const String id = 'EveningAzkarView';

  @override
  State<EveningAzkarView> createState() => _EveningAzkarViewState();
}

class _EveningAzkarViewState extends State<EveningAzkarView> {

  double fontSize = 16.0;


  final String boxName = 'evening_notification_box';

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final box = await Hive.openBox<EveningNotification>(boxName);
    final EveningNotification? savedModel = box.get('settings');

    if (savedModel != null) {
      setState(() {
        selectedEndTimeIndex = savedModel.endTime;
        selectedIntervalIndex = savedModel.intervalTime;
        selectedDateTime = savedModel.startTime;
        isSwitched = savedModel.isAllowed;
      });
    }
  }

  Future<void> saveSettings() async {
    final box = await Hive.openBox<EveningNotification>(boxName);
    final eveningAzkarModel = EveningNotification(
      endTime: selectedEndTimeIndex,
      intervalTime: selectedIntervalIndex,
      startTime: selectedDateTime,
      isAllowed: isSwitched,
    );
    await box.put('settings', eveningAzkarModel);
  }


  int selectedEndTimeIndex = 0; // Default index for end time
  int selectedIntervalIndex = 0; // Default index for interval

  List<String> endTimes = [
    'ساعه',
    'ساعتين',
    '٣ ساعات',
  ];

  List<String> intervals = [
    'دقيقة',
    '٥ دقائق',
    '١٠ دقائق',
  ];

  List<int> repeatingNotificationIds = [];

  DateTime selectedDateTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0);

  bool isSwitched = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (picked != null) {
      DateTime selectedTime = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        picked.hour,
        picked.minute,
      );

      // Check if the selected time is before the current time
      if (selectedTime.isBefore(DateTime.now())) {
        // If it's in the past, add one day to the selected date
        selectedTime = selectedTime.add(const Duration(days: 1));
      } else {
        // If it's in the future, set it to today
        selectedTime = DateTime(
          DateTime
              .now()
              .year,
          DateTime
              .now()
              .month,
          DateTime
              .now()
              .day,
          picked.hour,
          picked.minute,
        );
      }

      // Cancel existing notifications
      for (int notificationId in repeatingNotificationIds) {
        AwesomeNotifications().cancelSchedule(notificationId);
      }

      setState(() {
        selectedDateTime = selectedTime;
      });

      // If the switch is on, reschedule notifications
      if (isSwitched) {
        scheduleRepeatingNotification(
          eveningList,
          selectedEndTimeIndex,
          selectedIntervalIndex,
        );
      }

      // Save the settings whenever the time is selected
      saveSettings();
    }
  }

  void scheduleRepeatingNotification(List<String> eveningList,
      int selectedEndTimeIndex,
      int selectedIntervalIndex,) async {
    String localTimeZone =
    await AwesomeNotifications().getLocalTimeZoneIdentifier();

    // Check if notifications are already scheduled
    if (repeatingNotificationIds.isNotEmpty) {
      // Cancel existing notifications
      for (int notificationId in repeatingNotificationIds) {
        AwesomeNotifications().cancelSchedule(notificationId);
      }
    }

    DateTime notificationStartTime = DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      selectedDateTime.hour,
      selectedDateTime.minute,
    );

    // Calculate the end time based on the selected option
    DateTime notificationEndTime;
    switch (selectedEndTimeIndex) {
      case 0: // 1 hour
        notificationEndTime =
            notificationStartTime.add(const Duration(hours: 1));
        break;
      case 1: // 2 hours
        notificationEndTime =
            notificationStartTime.add(const Duration(hours: 2));
        break;
      case 2: // 3 hours
        notificationEndTime =
            notificationStartTime.add(const Duration(hours: 3));
        break;
      default:
      // Default to 1 hour
        notificationEndTime =
            notificationStartTime.add(const Duration(hours: 1));
        break;
    }

    // Calculate the time difference between start and end times
    Duration timeDifference =
    notificationEndTime.difference(notificationStartTime);

    // Calculate the interval duration based on the selected option
    int intervalInMinutes;
    switch (selectedIntervalIndex) {
      case 0: // 1 minute
        intervalInMinutes = 1;
        break;
      case 1: // 5 minutes
        intervalInMinutes = 5;
        break;
      case 2: // 10 minutes
        intervalInMinutes = 10;
        break;
      default:
      // Default to 1 minute
        intervalInMinutes = 1;
        break;
    }

    // Calculate the number of intervals based on the selected option
    int intervals = timeDifference.inMinutes ~/ intervalInMinutes;

    // Schedule notifications with the selected interval
    for (int i = 0; i < intervals && i < eveningList.length; i++) {
      DateTime scheduledTime =
      notificationStartTime.add(Duration(minutes: i * intervalInMinutes));

      int notificationId = i + 1;
      repeatingNotificationIds.add(notificationId);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'basic_channel',
          title: 'أذكار المساء',
          body: eveningList[i], // Use the body from the list
        ),
        schedule: NotificationCalendar(
          timeZone: localTimeZone,
          year: scheduledTime.year,
          month: scheduledTime.month,
          day: scheduledTime.day,
          hour: scheduledTime.hour,
          minute: scheduledTime.minute,
          second: 0,
          allowWhileIdle: true,
          repeats: true,
        ),
      );

      debugPrint(localTimeZone);
      debugPrint(scheduledTime.year.toString());
      debugPrint(scheduledTime.month.toString());
      debugPrint(scheduledTime.day.toString());
      debugPrint(scheduledTime.hour.toString());
      debugPrint(scheduledTime.minute.toString());
    }
    // Save the settings whenever the switch is changed
    saveSettings();
  }

  List<String> eveningList = [
    "بسمِ اللهِ الذي لا يَضرُ مع اسمِه شيءٌ في الأرضِ ولا في السماءِ وهو السميعُ العليمِ",
    "رَضِيتُ بِاللهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا، إِلَّا كَانَ حَقًّا عَلَى اللهِ أَنْ يُرْضِيَهُ يَوْمَ الْقِيَامَةِ",
    "اللَّهمَّ بِكَ أمسَينا وبِكَ أصبَحنا وبِكَ نحيا وبِكَ نموتُ وإليكَ المصير",
    "سبحانَ اللَّهِ وبحمدِهِ مئةَ مرَّةٍ: لم يأتِ أحدٌ يومَ القيامةِ بأفضلَ ممَّا جاءَ بِهِ، إلَّا أحدٌ قالَ مثلَ ما قالَ، أو زادَ علَيهِ",
    "سُبْحَانَ اللهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
    "اللَّهُمَّ إنِّي أمسيت أُشهِدُك، وأُشهِدُ حَمَلةَ عَرشِكَ، ومَلائِكَتَك، وجميعَ خَلقِكَ: أنَّكَ أنتَ اللهُ لا إلهَ إلَّا أنتَ، وأنَّ مُحمَّدًا عبدُكَ ورسولُكَ",
    "اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ على نَبِيِّنَا مُحمَّد، فقد جاء في الحديث: مَن صلى عَلَيَّ حين يُصْبِحُ عَشْرًا، وحين يُمْسِي عَشْرًا، أَدْرَكَتْه شفاعتي يومَ القيامةِ",
    "لا إلهَ إلَّا اللهُ وحدَه لا شريكَ له له الملكُ وله الحمدُ وهو على كلِّ شيءٍ قديرٌ",
    "أمسَيْنا على فِطرةِ الإسلامِ وعلى كَلِمةِ الإخلاصِ وعلى دينِ نبيِّنا محمَّدٍ صلَّى اللهُ عليه وسلَّم وعلى مِلَّةِ أبينا إبراهيمَ حنيفًا مسلمًا وما كان مِنَ المشركينَ",
    "اللَّهمَّ ما أصبح بي مِن نعمةٍ أو بأحَدٍ مِن خَلْقِكَ، فمنكَ وحدَكَ لا شريكَ لكَ، فلَكَ الحمدُ ولكَ الشُّكرُ",
    "بسمِ اللهِ الذي لا يَضرُ مع اسمِه شيءٌ في الأرضِ ولا في السماءِ وهو السميعُ العليمِ",
    "رَضِيتُ بِاللهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا، إِلَّا كَانَ حَقًّا عَلَى اللهِ أَنْ يُرْضِيَهُ يَوْمَ الْقِيَامَةِ",
    "اللَّهمَّ بِكَ أمسَينا وبِكَ أصبَحنا وبِكَ نحيا وبِكَ نموتُ وإليكَ المصير",
    "سبحانَ اللَّهِ وبحمدِهِ مئةَ مرَّةٍ: لم يأتِ أحدٌ يومَ القيامةِ بأفضلَ ممَّا جاءَ بِهِ، إلَّا أحدٌ قالَ مثلَ ما قالَ، أو زادَ علَيهِ",
    "سُبْحَانَ اللهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
    "اللَّهُمَّ إنِّي أمسيت أُشهِدُك، وأُشهِدُ حَمَلةَ عَرشِكَ، ومَلائِكَتَك، وجميعَ خَلقِكَ: أنَّكَ أنتَ اللهُ لا إلهَ إلَّا أنتَ، وأنَّ مُحمَّدًا عبدُكَ ورسولُكَ",
    "اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ على نَبِيِّنَا مُحمَّد، فقد جاء في الحديث: مَن صلى عَلَيَّ حين يُصْبِحُ عَشْرًا، وحين يُمْسِي عَشْرًا، أَدْرَكَتْه شفاعتي يومَ القيامةِ",
    "لا إلهَ إلَّا اللهُ وحدَه لا شريكَ له له الملكُ وله الحمدُ وهو على كلِّ شيءٍ قديرٌ",
    "أمسَيْنا على فِطرةِ الإسلامِ وعلى كَلِمةِ الإخلاصِ وعلى دينِ نبيِّنا محمَّدٍ صلَّى اللهُ عليه وسلَّم وعلى مِلَّةِ أبينا إبراهيمَ حنيفًا مسلمًا وما كان مِنَ المشركينَ",
    "اللَّهمَّ ما أصبح بي مِن نعمةٍ أو بأحَدٍ مِن خَلْقِكَ، فمنكَ وحدَكَ لا شريكَ لكَ، فلَكَ الحمدُ ولكَ الشُّكرُ",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1D1A1B),
      appBar: AppBar(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(30),
        //     bottomRight: Radius.circular(30),
        //   )
        // ),
        backgroundColor:MyColors.azkarColor ,
        centerTitle: true,
        title: const Text(
          'أذكار المساء'
          , style: TextStyle(
          color: Color(0xff1D1A1B),
        ),
        ),
        actions: [
          PopupMenuButton<double>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
              const PopupMenuItem<double>(
                value: 16,
                child: Text('حجم الخط 16'),
              ),
              const PopupMenuItem<double>(
                value: 24,
                child: Text('حجم الخط 24'),
              ),
              const PopupMenuItem<double>(
                value: 30,
                child: Text('حجم الخط 30'),
              ),
            ],
            onSelected: (double selectedFontSize) {
              // Handle the selected font size here
              print('Selected Font Size: $selectedFontSize');
              setState(() {
                fontSize = selectedFontSize;
              });
              // You can apply the selected font size to your text or perform other actions
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: const BoxDecoration(
                  color:MyColors.azkarColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'تفعيل الاشعارات',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        value: isSwitched,
                        activeColor:MyColors.azkarColor,
                        activeTrackColor: const Color(0xff1D1A1B),
                        inactiveTrackColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            if (isSwitched) {
                              // Call the notification function when the switch is turned on
                              scheduleRepeatingNotification(
                                eveningList,
                                selectedEndTimeIndex,
                                selectedIntervalIndex,
                              );
                            } else {
                              for (int notificationId
                                  in repeatingNotificationIds) {
                                AwesomeNotifications()
                                    .cancelSchedule(notificationId);
                                saveSettings();
                              }
                            }
                          });
                          // Save the settings whenever the switch is changed
                          saveSettings();
                        },
                      ),
                      Row(
                        children: [
                          const Text(
                            'الوقت المحدد لارسال الاشعارات :',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat.jm().format(selectedDateTime),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () => _selectTime(context),
                              icon: const Icon(Icons.edit_calendar)),
                        ],
                      ),

                      Row(
                        children: [
                          const Text(
                            'وقت الانتهاء:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          DropdownButton<int>(
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.circular(16),
                            value: selectedEndTimeIndex,
                            style: const TextStyle(color: Colors.black),
                            dropdownColor: Colors.white,
                            items: endTimes.map((String value) {
                              return DropdownMenuItem<int>(
                                value: endTimes.indexOf(value),
                                child: Text(
                                  value,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedEndTimeIndex = newValue!;
                              });
                              // Handle the selected end time here
                              debugPrint(
                                  'Selected End Time: ${endTimes[selectedEndTimeIndex]}');
                            },
                          ),
                          const Spacer(),
                          const Text(
                            'الفاصل  بين الإشعارات:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          DropdownButton<int>(
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.circular(16),
                            value: selectedIntervalIndex,
                            dropdownColor: Colors.white,
                            style: const TextStyle(color: Colors.black),
                            items: intervals.map((String value) {
                              return DropdownMenuItem<int>(
                                value: intervals.indexOf(value),
                                child: Text(
                                  value,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedIntervalIndex = newValue!;
                              });
                              // Handle the selected interval here
                              debugPrint(
                                  'Selected Interval: ${intervals[selectedIntervalIndex]}');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: eveningList.length,
              (context, index) => Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 16),
                child: Container(
                  decoration: const BoxDecoration(
                    color: MyColors.azkarColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      eveningList[index],
                      style:  TextStyle(color: Colors.black  , fontSize: fontSize),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
