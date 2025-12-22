import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip Clock',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const FlipClockScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FlipClockScreen extends StatefulWidget {
  const FlipClockScreen({Key? key}) : super(key: key);

  @override
  State<FlipClockScreen> createState() => _FlipClockScreenState();
}

class _FlipClockScreenState extends State<FlipClockScreen> {
  late Timer _timer;
  late DateTime _currentTime;
  String _period = 'AM';

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _period = DateFormat('a').format(_currentTime);

    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        _period = DateFormat('a').format(_currentTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format time
    final hour = DateFormat('h').format(_currentTime);
    final minutes = DateFormat('mm').format(_currentTime);
    final seconds = DateFormat('ss').format(_currentTime);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // AM/PM indicator
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  _period,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Clock display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hour
                FlipNumber(
                  number: hour,
                  large: true,
                  key: ValueKey('hour-$hour'),
                ),
                const SizedBox(width: 30),
                // Minutes
                FlipNumber(
                  number: minutes[0],
                  key: ValueKey('min1-${minutes[0]}'),
                ),
                const SizedBox(width: 6),
                FlipNumber(
                  number: minutes[1],
                  key: ValueKey('min2-${minutes[1]}'),
                ),

                const SizedBox(width: 6),
                FlipNumber(
                  number: seconds[0],
                  key: ValueKey('sec1-${seconds[0]}'),
                ),

                const SizedBox(width: 6),
                FlipNumber(
                  number: seconds[1],
                  key: ValueKey('sec2-${seconds[1]}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlipNumber extends StatelessWidget {
  final String number;
  final bool large;

  const FlipNumber({
    Key? key,
    required this.number,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FlipTransition(
          child: child,
          animation: animation,
        );
      },
      child: _FlipCard(
        key: ValueKey<String>(number),
        number: number,
        large: large,
      ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  final String number;
  final bool large;

  const _FlipCard({
    Key? key,
    required this.number,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: large ? 120 : 80,
      height: large ? 180 : 140,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main number
          Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: large ? 150 : 100,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Top divider line
          Positioned(
            top: (large ? 180 : 140) / 2 - 1,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Slight gradient overlay for 3D effect
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlipTransition extends AnimatedWidget {
  final Widget child;

  FlipTransition({
    required this.child,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final halfTween = Tween(begin: 0.0, end: 0.5);
    final secondHalfTween = Tween(begin: 0.5, end: 1.0);

    return Stack(
      children: [
        // Front half (visible during first half of animation)
        animation.value <= 0.5
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-halfTween.animate(animation).value * 3.14),
                child: child,
              )
            : Container(),

        // Back half (visible during second half of animation)
        animation.value >= 0.5
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(
                      (1 - secondHalfTween.animate(animation).value) * 3.14),
                child: child,
              )
            : Container(),
      ],
    );
  }
}
