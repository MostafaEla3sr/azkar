import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 0)
class MorningNotification extends HiveObject {
  @HiveField(0)
  bool isAllowed;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  int endTime;

  @HiveField(3)
  int intervalTime;

  MorningNotification({
    required this.isAllowed,
    required this.startTime,
    required this.endTime,
    required this.intervalTime,
  });
}

@HiveType(typeId: 1)
class EveningNotification extends HiveObject {
  @HiveField(0)
  bool isAllowed;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  int endTime;

  @HiveField(3)
  int intervalTime;

  EveningNotification({
    required this.isAllowed,
    required this.startTime,
    required this.endTime,
    required this.intervalTime,
  });
}


