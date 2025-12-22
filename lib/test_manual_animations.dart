import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(FlipClockApp());
}

class FlipClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlipClock(),
    );
  }
}

class FlipClock extends StatefulWidget {
  @override
  _FlipClockState createState() => _FlipClockState();
}

class _FlipClockState extends State<FlipClock> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildFlipCard({required String text, double? fontSize = 80}) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
      child: Text(
        text,
        key: ValueKey<String>(text),
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFlipCard(text: (_now.hour % 12).toString().padLeft(2, '0')),
            SizedBox(width: 8),
            _buildFlipCard(text: _now.minute.toString().padLeft(2, '0')),
            SizedBox(width: 8),
            _buildFlipCard(
                text: _now.second.toString().padLeft(2, '0'), fontSize: 20),
          ],
        ),
      ),
    );
  }
}
