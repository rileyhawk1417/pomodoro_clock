import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_clock/bloc/settings/settings_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_clock/ui/digital_clock/landscape_widget.dart';
import 'dart:async';

import 'package:pomodoro_clock/ui/digital_clock/potrait_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class DigitalClockScreen extends StatefulWidget {
  const DigitalClockScreen({Key? key}) : super(key: key);

  @override
  State<DigitalClockScreen> createState() => _DigitalClockScreenState();
}

class _DigitalClockScreenState extends State<DigitalClockScreen> {
  late Timer _timer;
  late String _period;

  late String _hour;
  late String _minute;
  late String _second;
  late String _twentyFourHour;

  @override
  void initState() {
    super.initState();
    _updateTime();

    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final period = DateFormat('a').format(now);
    final minutes = DateFormat('mm').format(now);
    final seconds = DateFormat('ss').format(now);
    final twentyFourHour = DateFormat('H').format(now);
    setState(() {
      _period = period;
      _minute = minutes;
      _second = seconds;
      _twentyFourHour = twentyFourHour;
      _hour = now.hour % 12 == 0
          ? '12'
          : (now.hour % 12).toString().padLeft(2, '0');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final isPotrait = mediaQuery.orientation == Orientation.portrait;
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTwelveHoursEnabled = context.select(
              (SettingsBloc bloc) => bloc.state.settings.twelveHourNotation);
          final alwaysOn = context
              .select((SettingsBloc bloc) => bloc.state.settings.alwaysOn);
          final showSeconds = context
              .select((SettingsBloc bloc) => bloc.state.settings.showSeconds);
          if (alwaysOn) {
            WakelockPlus.enable();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isTwelveHoursEnabled
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                          child: Text(
                            _period,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: screenHeight * 0.040),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              isTwelveHoursEnabled
                  ? const SizedBox(height: 5)
                  : const SizedBox.shrink(),
              isPotrait
                  ? DigitalClockPotraitWidget(
                      key: const ValueKey('potrait_layout'),
                      constraints: constraints,
                      second: _second,
                      minute: _minute,
                      showSeconds: showSeconds,
                      hour: isTwelveHoursEnabled ? _hour : _twentyFourHour)
                  : DigitalClockLandscapeWidget(
                      key: const ValueKey('landscape_layout'),
                      constraints: constraints,
                      second: _second,
                      minute: _minute.toString(),
                      showSeconds: showSeconds,
                      hour: isTwelveHoursEnabled ? _hour : _twentyFourHour),
            ],
          );
        },
      ),
    );
  }
}
