import 'package:bloc/bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:pomodoro_clock/hive/settings_model.dart';

import 'package:equatable/equatable.dart';
// import 'package:pomodoro_clock/hive/settings_model.dart';

part './settings_event.dart';
part './settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Box<SettingsModel> settingsBox;

  SettingsBloc(this.settingsBox)
      : super(
          SettingsState(
            settings: settingsBox.get('settings') ??
                SettingsModel(
                    workDuration: 0,
                    breakDuration: 0,
                    alertRepeatCount: 0,
                    workEndSound: '',
                    breakEndSound: '',
                    defaultLabel: LabelsModel(label: '', color: ''),
                    showSeconds: true,
                    twelveHourNotation: true,
                    alwaysOn: false),
          ),
        ) {
    on<LoadSettings>(_onLoadSettings);
    on<SetBreakDuration>(_onSetBreakDuration);
    on<SetWorkDuration>(_onSetWorkDuration);
    on<SetAlertRepeatCount>(_onSetAlertRepeatCount);
    on<SetWorkEndSound>(_onSetWorkEndSound);
    on<SetBreakEndSound>(_onSetBreakEndSound);
    on<SetDefaultLabel>(_onSetDefaultLabel);
    on<SetTweleveHourNotation>(_onSetTweleveHourNotation);
    on<SetShowSeconds>(_onSetShowSeconds);
    on<SetAlwaysOn>(_onSetAlwaysOn);
    // on<SetAlertRepeatCount>(_onSetAlertRepeatCount);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final settings = settingsBox.get('settings') ?? state.settings;
    emit(SettingsState(settings: settings));
  }

  // void _onToggleDarkMode(ToggleDarkMode event, Emitter<SettingsState> emit) {
  //   final newSettings =
  //       state.settings.copyWith(isDarkMode: !state.settings.isDarkMode);
  //   settingsBox.put('settings', newSettings);
  //   emit(SettingsState(settings: newSettings));
  // }

  void _onSetBreakDuration(
      SetBreakDuration event, Emitter<SettingsState> emit) {
    final newSettings = state.settings.copyWith(breakDuration: event.duration);
    settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  void _onSetWorkDuration(SetWorkDuration event, Emitter<SettingsState> emit) {
    final newSettings = state.settings.copyWith(workDuration: event.duration);
    settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  void _onSetAlertRepeatCount(
      SetAlertRepeatCount event, Emitter<SettingsState> emit) {
    final newSettings = state.settings.copyWith(alertRepeatCount: event.count);
    settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  void _onSetWorkEndSound(
      SetWorkEndSound event, Emitter<SettingsState> emit) async {
    final newSettings = state.settings.copyWith(workEndSound: event.sound);
    await settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  void _onSetBreakEndSound(
      SetBreakEndSound event, Emitter<SettingsState> emit) {
    final newSettings = state.settings.copyWith(breakEndSound: event.sound);
    settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  void _onSetDefaultLabel(SetDefaultLabel event, Emitter<SettingsState> emit) {
    final newSettings = state.settings.copyWith(defaultLabel: event.label);
    settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  void _onSetTweleveHourNotation(
      SetTweleveHourNotation event, Emitter<SettingsState> emit) {
    final newSettings =
        state.settings.copyWith(twelveHourNotation: event.isTwelveHourNotation);
    settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  void _onSetShowSeconds(SetShowSeconds event, Emitter<SettingsState> emit) {
    final newSettings = state.settings.copyWith(showSeconds: event.showSeconds);
    settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  void _onSetAlwaysOn(SetAlwaysOn event, Emitter<SettingsState> emit) {
    final newSettings = state.settings.copyWith(alwaysOn: event.alwaysOn);
    settingsBox.put('settings', newSettings);
    emit(SettingsState(settings: newSettings));
  }

  // void _onToggleKeepScreenOn(
  //     ToggleKeepScreenOn event, Emitter<SettingsState> emit) {
  //   final newSettings =
  //       state.settings.copyWith(keepScreenOn: !state.settings.keepScreenOn);
  //   settingsBox.put('settings', newSettings);
  //   emit(SettingsState(settings: newSettings));
  // }
}
