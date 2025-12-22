import 'package:flutter/material.dart';
import 'package:pomodoro_clock/bloc/session/sessions_bloc.dart';
import 'package:pomodoro_clock/bloc/settings/settings_bloc.dart';
import 'package:pomodoro_clock/bloc/timer/timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_clock/hive/settings_model.dart';
import 'dart:async';

import 'package:pomodoro_clock/ui/widgets/timer_digit_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration _remainingTime = const Duration(hours: 0, minutes: 1, seconds: 0);
  Timer? _timer;
  bool _isRunning = false;

  void startCountDown() {
    if (_timer != null) return;
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
      } else {
        stopCountDown();
      }
    });
  }

  void stopCountDown() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void resetCountDown() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
      _remainingTime = const Duration(hours: 0, minutes: 1, seconds: 0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickTime(TimerBloc timerBloc, SessionsBloc sessionBloc,
      LabelsModel defaultLabel) async {
    TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 0, minute: 1));
    if (picked != null) {
      setState(() {
        _remainingTime =
            Duration(hours: picked.hour, minutes: picked.minute, seconds: 0);
      });
      timerBloc.add(
        TimerStarted(duration: _remainingTime.inSeconds),
      );

      sessionBloc.add(SessionStarted(
          defaultLabel.label, defaultLabel.color, _remainingTime.inSeconds));
      startCountDown();
    }
  }

  Future<void> _startDefault(TimerBloc timerBloc, SessionsBloc sessionBloc,
      LabelsModel defaultLabel) async {
    setState(() {
      _remainingTime = Duration(
          hours: 0,
          minutes: context.read<SettingsBloc>().state.settings.workDuration,
          seconds: 0);
    });
    timerBloc.add(
      TimerStarted(duration: _remainingTime.inSeconds),
    );
    sessionBloc.add(SessionStarted(
        defaultLabel.label, defaultLabel.color, _remainingTime.inSeconds));
    startCountDown();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final dur = context.select((TimerBloc bloc) => bloc.state.duration);
    final duration = Duration(seconds: dur);
    return Center(
      child: dur > 0
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: DigitalClockTimer(
                hour: duration.inHours.toString(),
                second:
                    duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
                minute: (duration.inMinutes % 60).toString().padLeft(2, '0'),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: mediaQuery.height / 2.8),
                  child: SizedBox(
                    height: 180,
                    child: Column(children: [
                      SizedBox(
                        height: 35,
                        width: mediaQuery.width / 1.6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white70.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Label: ${context.read<SettingsBloc>().state.settings.defaultLabel.label}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _startDefault(
                            context.read<TimerBloc>(),
                            context.read<SessionsBloc>(),
                            context
                                .read<SettingsBloc>()
                                .state
                                .settings
                                .defaultLabel),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white70.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(14.0),
                              ),
                            ),
                            child: SizedBox(
                              height: 40,
                              width: mediaQuery.width / 1.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.play_arrow),
                                  Text(
                                      'Default ${context.read<SettingsBloc>().state.settings.workDuration}mins')
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => _pickTime(
                            context.read<TimerBloc>(),
                            context.read<SessionsBloc>(),
                            context
                                .read<SettingsBloc>()
                                .state
                                .settings
                                .defaultLabel),
                        child: const Text('Pick a time'),
                      )
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}
