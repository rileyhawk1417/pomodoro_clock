import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pomodoro_clock/bloc/settings/settings_bloc.dart';
import 'package:pomodoro_clock/bloc/timer/tick.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part './timer_event.dart';
part './timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Tick ticker, required SettingsBloc settingsBloc})
      : _ticker = ticker,
        _settingsBloc = settingsBloc,
        _player = AudioPlayer(),
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<_TimerTicked>(_onTicked);
  }

  final Tick _ticker;
  final SettingsBloc _settingsBloc;
  static const int _duration = 0;
  static const bool isRunning = false;
  final AudioPlayer _player;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    WakelockPlus.enable();
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(_TimerTicked(duration: duration)));
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) async {
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration)
          : const TimerRunComplete(),
    );
    if (event.duration == 0) {
      WakelockPlus.disable();
      int counter = 0;
      final workEndSound =
          _settingsBloc.settingsBox.get('settings')?.workEndSound;
      for (int count = 0; counter < 2; counter++) {
        //TODO: Put this back
        //await _playAlert(workEndSound);
      }
    }
  }

  Future<void> _playAlert(soundAsset) async {
    try {
      final audioSource = AudioSource.asset(soundAsset);
      await _player.setAudioSource(audioSource);
      await _player.setVolume(2.0);
      await _player.play();
    } catch (e) {
      debugPrint("Error playing alert: $e");
    }
  }
}

Future<File> writeAssetToFile(String assetPath, String filename) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/$filename');
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file;
}
