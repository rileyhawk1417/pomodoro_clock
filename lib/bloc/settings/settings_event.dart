part of 'settings_bloc.dart';

// abstract class SettingsEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
sealed class SettingsEvent {
  const SettingsEvent();
}

// Load settings from Hive
class LoadSettings extends SettingsEvent {}

// Toggle dark mode
class ToggleDarkMode extends SettingsEvent {}

// Toggle notifications
class ToggleNotifications extends SettingsEvent {}

// Toggle keep screen on
class ToggleKeepScreenOn extends SettingsEvent {}

class SetBreakEndSound extends SettingsEvent {
  const SetBreakEndSound({required this.sound});
  final String sound;
}

class SetWorkDuration extends SettingsEvent {
  const SetWorkDuration({required this.duration});
  final int duration;
}

class SetBreakDuration extends SettingsEvent {
  const SetBreakDuration({required this.duration});
  final int duration;
}

final class SetWorkEndSound extends SettingsEvent {
  const SetWorkEndSound({required this.sound});
  final String sound;
}

final class SetAlertRepeatCount extends SettingsEvent {
  const SetAlertRepeatCount({required this.count});
  final int count;
}

final class SetDefaultLabel extends SettingsEvent {
  const SetDefaultLabel({required this.label});
  final LabelsModel label;
}


final class SetTweleveHourNotation extends SettingsEvent {
  const SetTweleveHourNotation({required this.isTwelveHourNotation});
  final bool isTwelveHourNotation;
}


final class SetShowSeconds extends SettingsEvent {
  const SetShowSeconds({required this.showSeconds});
  final bool showSeconds;
}

final class SetAlwaysOn extends SettingsEvent {
  const SetAlwaysOn({required this.alwaysOn});
  final bool alwaysOn;
}
