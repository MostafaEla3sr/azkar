import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SebhaView extends StatefulWidget {
  const SebhaView({Key? key}) : super(key: key);
  static const String id = 'SebhaView';

  @override
  State<SebhaView> createState() => _SebhaViewState();
}

class _SebhaViewState extends State<SebhaView> {
  int totalMonthCount = 0;

  // final String boxName = 'sebha_history_box';
  // @override
  // void initState() {
  //   super.initState();
  //   loadSettings();
  // }
  //
  // Future<void> loadSettings() async {
  //   final box = await Hive.openBox<SebhaHistoryModel>(boxName);
  //   final SebhaHistoryModel? savedModel = box.get('settings');
  //
  //   if (savedModel != null) {
  //     setState(() {
  //       selectedEndTimeIndex = savedModel.endTime;
  //       selectedIntervalIndex = savedModel.intervalTime;
  //       selectedDateTime = savedModel.startTime;
  //       isSwitched = savedModel.isAllowed;
  //     });
  //   }
  // }
  //
  // Future<void> saveSettings() async {
  //   final box = await Hive.openBox<MorningNotification>(boxName);
  //   final morningAzkarModel = MorningNotification(
  //     endTime: selectedEndTimeIndex,
  //     intervalTime: selectedIntervalIndex,
  //     startTime: selectedDateTime,
  //     isAllowed: isSwitched,
  //   );
  //   await box.put('settings', morningAzkarModel);
  // }
  //
  //

  List<String> sebhaList = [
    'استغفر الله',
    'الحمد لله',
    'سبحان الله',
    'الله أكبر',
    'لا إله إلا الله',
  ];

  // Function to build the content of the dialog
  Widget _buildTotalCountsDialog(Map<String, int> countsMap, int totalMonthCount) {
    return AlertDialog(

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('سجل التسبيحات'),
          IconButton(
            onPressed: () async {
              // Show a confirmation dialog
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('تأكيد الحذف'),
                    content: const Text('هل أنت متأكد أنك تريد حذف هذا؟'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Reset the historical values to 0


                          // Trigger a rebuild of the widget tree
                          setState(() {
                            Hive.box('sebha_box').clear();
                          });

                          // Close the dialog
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('حذف'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('إلغاء'),
                      ),
                    ],
                  );
                },
              );

              // Rebuild the widget tree after the dialog is closed
              setState(() {});
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          )

          // IconButton(
          //   onPressed: () {
          //     // Show a confirmation dialog
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: Text('تأكيد الحذف'),
          //           content: Text('هل أنت متأكد أنك تريد حذف هذا؟'),
          //           actions: [
          //             TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context); // Close the dialog
          //               },
          //               child: Text('إلغاء'),
          //             ),
          //             TextButton(
          //               onPressed: () {
          //                 // Reset the historical values to 0
          //                 // Replace 'history_box' with the actual name of your history box
          //                 Hive.box('sebha_box').clear();
          //                 setState(() {
          //
          //                 });// Clear all values in the history box
          //
          //                 // Close the dialog
          //                 Navigator.pop(context);
          //               },
          //               child: Text('حذف'),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          //   icon: Icon(
          //     Icons.delete,
          //     color: Colors.red,
          //   ),
          // )


        ],
      ),
      content: SizedBox(
        height:270,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: [

                // Display individual counts
                ...countsMap.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric( vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${entry.key}: ' , style: const TextStyle(fontSize: 18),),

                        Text('${entry.value}' , style: const TextStyle(fontSize: 18),),

                      ],
                    ),
                  );
                }).toList(),

                const Divider(), // Add a divider for better separation

                // Display the total count for the month
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('إجمالي التسبيحات : ' , style: TextStyle(
                      fontSize: 14,
                    ),),
                    Text('$totalMonthCount', style: const TextStyle(
                      fontSize: 14,
                    ),),
                  ],
                ),
              ],


            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('إغلاق' ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box('sebha_box').listenable(),
        builder: (context, box, child) {
          var count = box.get('count', defaultValue: 0);
          var totalCount = box.get('totalCount', defaultValue: 0);
          var selectedIndex = box.get('selectedIndex', defaultValue: 0);

          Map<String, int> countsMap = Map.fromIterable(sebhaList,
              key: (item) => item,
              value: (item) => box.get(item, defaultValue: 0));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 1,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.chevron_left , size: 30,),
                      ),
                      // Spacer(),
                      // Text('سبحه'),
                      // Spacer(),
                      IconButton(
                        onPressed: (){
                          Map<String, int> countsMap = Map.fromIterable(sebhaList,
                              key: (item) => item,
                              value: (item) => Hive.box('sebha_box').get(item, defaultValue: 0));

                          // Calculate the total count for the month
                          totalMonthCount = countsMap.values.fold(0, (sum, count) => sum + count);

                          // Show the dialog with the counts and the total for the month
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildTotalCountsDialog(countsMap, totalMonthCount);
                            },
                          );

                          },
                        icon: const Icon(Icons.history , size: 30,),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                Image.asset(
                  'assets/images/sebha.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                const Spacer(),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Color(0xff4C230D),
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        // minWidth: MediaQuery.sizeOf(context).width ,
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: const Color(0xffB85F05),
                        onPressed: () {
                          setState(() {
                            totalCount++;
                            count++;
                            countsMap[sebhaList[selectedIndex]] =
                                (countsMap[sebhaList[selectedIndex]] ?? 0) + 1;
                            // if (count == 33) {
                            //   count = 0;
                            //   selectedIndex =
                            //       (selectedIndex + 1) % sebhaList.length;
                            // }
                            box.put('count', count);
                            box.put('totalCount', totalCount);
                            box.put('selectedIndex', selectedIndex);
                            countsMap.forEach((key, value) {
                              box.put(key, value);
                            });
                          });
                        },
                        child: Text(
                          sebhaList[selectedIndex],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            16,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Color(0xff4C230D),
                      ),
                      onSelected: (newValue) {
                        setState(() {
                          if (newValue != sebhaList[selectedIndex]) {
                            // Reset count to 0 when changing the item
                            count = 0;
                            box.put('count', count);
                          }

                          selectedIndex = sebhaList.indexOf(newValue);
                          box.put('selectedIndex', selectedIndex);
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return sebhaList.map((String phrase) {
                          return PopupMenuItem<String>(
                            value: phrase,
                            child: Text(phrase),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الاجمالى : ${totalCount.toString()}',
                      style: const TextStyle(
                        color: Color(0xff4C230D),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          count = 0;
                          selectedIndex = 0;
                          totalCount = 0;
                          box.put('count', count);
                          box.put('totalCount', totalCount);
                          box.put('selectedIndex', selectedIndex);
                        });
                      },
                      icon: const Icon(
                        FontAwesomeIcons.arrowRotateRight,
                        color: Color(0xff4C230D),
                        size: 40,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

              ],
            ),
          );
        },
      ),
    );
  }
}
