import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_clock/ui/themes/dark_mode.dart';
import 'package:pomodoro_clock/ui/themes/light_mode.dart';
import 'package:pomodoro_clock/controllers/digital_clock/flip_clock.dart';

class DigitalClockLandscapeWidget extends StatelessWidget {
  const DigitalClockLandscapeWidget(
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
    return Row(
      key: const ValueKey('landscape'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Hour
        FlipDigit(
          value: hour,
          height: constraints.maxHeight * 0.80,
          width: constraints.maxWidth * 0.40,
          fontSize: constraints.maxHeight * 0.60,
        ),
        // const Padding(padding: EdgeInsets.only(left: 30, right: 30)),
        // Padding(
        //   padding: const EdgeInsets.only(top: 10.0),
        //   child: Text(':',
        //       style: TextStyle(fontSize: constraints.maxHeight * 0.35),
        //       textAlign: TextAlign.center),
        // ),

        const SizedBox(width: 4),
        FlipDigit(
          value: minute,
          height: constraints.maxHeight * 0.80,
          width: constraints.maxWidth * 0.40,
          fontSize: constraints.maxHeight * 0.60,
        ),
        showSeconds ? const SizedBox(width: 4) : const SizedBox.shrink(),
        showSeconds
            ? FlipDigit(
                value: second,
                height: constraints.maxHeight * 0.15,
                width: constraints.maxWidth * 0.08,
                fontSize: constraints.maxHeight * 0.10,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
