import 'package:hive_ce/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class LabelsModel {
  @HiveField(0)
  String label;
  @HiveField(1)
  String color;
  LabelsModel({required this.label, required this.color});
}

@HiveType(typeId: 0)
class SettingsModel extends HiveObject {
  @HiveField(0)
  int workDuration;
  @HiveField(1)
  int breakDuration;
  @HiveField(2)
  int alertRepeatCount;
  @HiveField(3)
  String workEndSound;
  @HiveField(4)
  String breakEndSound;
  @HiveField(5)
  LabelsModel defaultLabel;
  @HiveField(6)
  bool twelveHourNotation;
  @HiveField(7)
  bool showSeconds;
  @HiveField(8)
  bool alwaysOn;

  SettingsModel(
      {required this.workDuration,
      required this.breakDuration,
      required this.alertRepeatCount,
      required this.workEndSound,
      required this.breakEndSound,
      required this.defaultLabel,
      required this.twelveHourNotation,
      required this.showSeconds,
      required this.alwaysOn});

  SettingsModel copyWith(
      {int? workDuration,
      int? breakDuration,
      int? alertRepeatCount,
      String? workEndSound,
      String? breakEndSound,
      LabelsModel? defaultLabel,
      bool? twelveHourNotation,
      bool? showSeconds,
      bool? alwaysOn}) {
    return SettingsModel(
        workDuration: workDuration ?? this.workDuration,
        breakDuration: breakDuration ?? this.breakDuration,
        alertRepeatCount: alertRepeatCount ?? this.alertRepeatCount,
        workEndSound: workEndSound ?? this.workEndSound,
        breakEndSound: breakEndSound ?? this.breakEndSound,
        defaultLabel: defaultLabel ?? this.defaultLabel,
        twelveHourNotation: twelveHourNotation ?? this.twelveHourNotation,
        showSeconds: showSeconds ?? this.showSeconds,
        alwaysOn: alwaysOn ?? this.alwaysOn);
  }
}
