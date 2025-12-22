import 'dart:async';
import 'dart:math' as math;
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
  late String _hour1;
  late String _hour2;
  late String _minute1;
  late String _minute2;
  late String _period;

  late String _second1;
  late String _second2;

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
    final hour = DateFormat('hh').format(now);
    final minutes = DateFormat('mm').format(now);
    final period = DateFormat('a').format(now);
    final seconds = DateFormat('ss').format(now);

    setState(() {
      _hour1 = hour[0];
      _hour2 = hour[1];
      _minute1 = minutes[0];
      _minute2 = minutes[1];
      _second1 = seconds[0];
      _second2 = seconds[1];

      _period = period;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                FlipDigit(
                  value: _hour1,
                  height: 180,
                  width: 120,
                  fontSize: 150,
                ),

                // Hour
                FlipDigit(
                  value: _hour2,
                  height: 180,
                  width: 120,
                  fontSize: 150,
                ),
                const SizedBox(width: 30),
                // Minutes
                FlipDigit(
                  value: _minute1,
                  height: 140,
                  width: 80,
                  fontSize: 100,
                ),

                FlipDigit(
                  value: _minute2,
                  height: 140,
                  width: 80,
                  fontSize: 100,
                ),

                const SizedBox(width: 6),
                FlipDigit(
                  value: _second1,
                  height: 80,
                  width: 40,
                  fontSize: 50,
                ),
                const SizedBox(width: 6),
                FlipDigit(
                  value: _second2,
                  height: 80,
                  width: 40,
                  fontSize: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlipDigit extends StatefulWidget {
  final String value;
  final double height;
  final double width;
  final double fontSize;

  const FlipDigit({
    Key? key,
    required this.value,
    required this.height,
    required this.width,
    required this.fontSize,
  }) : super(key: key);

  @override
  State<FlipDigit> createState() => _FlipDigitState();
}

class _FlipDigitState extends State<FlipDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String _oldValue;
  late String _newValue;

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value;
    _newValue = widget.value;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(FlipDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _oldValue = oldWidget.value;
      _newValue = widget.value;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          width: widget.width,
          child: Stack(
            children: [
              // Bottom card (static)
              Positioned(
                top: widget.height / 2,
                child: _buildCard(
                  height: widget.height / 2,
                  width: widget.width,
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: _buildDigitText(
                    value: _animation.value < 0.5 ? _oldValue : _newValue,
                    fontSize: widget.fontSize,
                    isTop: false,
                  ),
                ),
              ),

              // Top card (static)
              Positioned(
                top: 0,
                child: _buildCard(
                  height: widget.height / 2,
                  width: widget.width,
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: _buildDigitText(
                    value: _animation.value < 0.5 ? _oldValue : _newValue,
                    fontSize: widget.fontSize,
                    isTop: true,
                  ),
                ),
              ),

              // Flipping bottom (dynamic)
              _buildFlipPanel(
                value: _oldValue,
                flipUp: false,
                perspective: _animation.value,
              ),

              // Flipping top (dynamic)
              _buildFlipPanel(
                value: _newValue,
                flipUp: true,
                perspective: _animation.value,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFlipPanel({
    required String value,
    required bool flipUp,
    required double perspective,
  }) {
    // Only show this panel during its half of the animation
    final show = flipUp ? perspective >= 0.5 : perspective < 0.5;

    if (!show) {
      return const SizedBox.shrink();
    }

    // Calculate rotation based on animation and flip direction
    double rotationFactor;
    if (flipUp) {
      rotationFactor = -math.pi * (1.5 - perspective * 2);
    } else {
      rotationFactor = -math.pi * perspective * 2;
    }

    return Positioned(
      top: flipUp ? widget.height / 2 : 0,
      child: Transform(
        alignment: flipUp ? Alignment.topCenter : Alignment.bottomCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(rotationFactor),
        child: _buildCard(
          height: widget.height / 2,
          width: widget.width,
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(flipUp ? 0 : 10),
            topRight: Radius.circular(flipUp ? 0 : 10),
            bottomLeft: Radius.circular(flipUp ? 10 : 0),
            bottomRight: Radius.circular(flipUp ? 10 : 0),
          ),
          child: _buildDigitText(
            value: flipUp ? _newValue : _oldValue,
            fontSize: widget.fontSize,
            isTop: !flipUp,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required double height,
    required double width,
    required Color color,
    required BorderRadius borderRadius,
    required Widget child,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
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
      child: child,
    );
  }

  Widget _buildDigitText({
    required String value,
    required double fontSize,
    required bool isTop,
  }) {
    return ClipRect(
      child: Align(
        alignment: isTop ? Alignment.bottomCenter : Alignment.topCenter,
        heightFactor: 0.5,
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
