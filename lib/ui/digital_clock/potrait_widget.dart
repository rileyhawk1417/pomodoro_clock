import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_clock/ui/themes/dark_mode.dart';
import 'package:pomodoro_clock/ui/themes/light_mode.dart';
import 'package:pomodoro_clock/controllers/digital_clock/flip_clock.dart';

class DigitalClockPotraitWidget extends StatelessWidget {
  const DigitalClockPotraitWidget(
      {Key? key,
      required this.constraints,
      // required this.period,
      required this.hour,
      required this.minute,
      required this.second,
      required this.showSeconds})
      : super(key: key);
  final BoxConstraints constraints;
  // final String period;
  final String hour;
  final String minute;
  final String second;
  final bool showSeconds;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('potrait'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour
        FlipDigit(
          value: hour,
          height: constraints.maxHeight * 0.36,
          width: constraints.maxWidth * 0.70,
          fontSize: constraints.maxHeight * 0.28,
        ),

        const SizedBox(height: 4),

        // Minutes
        FlipDigit(
          value: minute,
          height: constraints.maxHeight * 0.36,
          width: constraints.maxWidth * 0.70,
          fontSize: constraints.maxHeight * 0.28,
        ),

        showSeconds ? const SizedBox(height: 4) : const SizedBox.shrink(),
        showSeconds
            ? FlipDigit(
                value: second,
                height: constraints.maxHeight * 0.12,
                width: constraints.maxWidth * 0.30,
                fontSize: constraints.maxHeight * 0.10,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
