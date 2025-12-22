import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_clock/ui/themes/dark_mode.dart';
import 'package:pomodoro_clock/ui/themes/light_mode.dart';

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

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _oldValue = _newValue;
        });
        _controller.reset();
      }
    });
  }

  @override
  void didUpdateWidget(FlipDigit oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      _oldValue = oldWidget.value;
      _newValue = widget.value;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          child: Column(
            children: [
              // Top half
              Stack(
                children: [
                  // Static top half
                  _buildCardHalf(
                    top: false,
                    value: _newValue,
                    height: widget.height / 2,
                    width: widget.width,
                    fontSize: widget.fontSize,
                    theme: theme,
                  ),
                  // Flipping top half (only visible during second half of animation)
                  if (_animation.value <= 0.5)
                    Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(-math.pi * _animation.value),
                      child: _buildCardHalf(
                        top: false,
                        value: _oldValue,
                        height: widget.height / 2,
                        width: widget.width,
                        fontSize: widget.fontSize,
                        theme: theme,
                      ),
                    ),
                ],
              ),

              Container(
                height: 2.0, // A thin physical-looking gap
                width: widget.width,
                decoration: BoxDecoration(
                  color: Colors.black, // Darkest point of the clock
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 1,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              // Bottom half
              Stack(
                children: [
                  // Static bottom half
                  _buildCardHalf(
                    top: true,
                    value: _animation.value <= 0.5 ? _oldValue : _newValue,
                    height: (widget.height / 2) - 2.7,
                    width: widget.width,
                    fontSize: widget.fontSize,
                    theme: theme,
                  ),

                  // Flipping bottom half (only visible during first half of animation)
                  if (_animation.value > 0.5)
                    Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(math.pi * (1 - _animation.value)),
                      child: _buildCardHalf(
                        top: true,
                        value: _newValue,
                        height: (widget.height / 2) - 2.7,
                        width: widget.width,
                        fontSize: widget.fontSize,
                        theme: theme,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardHalf({
    required bool top,
    required String value,
    required double height,
    required double width,
    required double fontSize,
    required ThemeData theme,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(top ? 0 : 10),
            topRight: Radius.circular(top ? 0 : 10),
            bottomLeft: Radius.circular(top ? 0 : 10),
            bottomRight: Radius.circular(top ? 0 : 10),
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: top
                  ? [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.white.withValues(alpha: 0.02)
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.2)
                    ])),
      child: ClipRect(
        child: OverflowBox(
          maxHeight: widget.height,
          //minHeight: widget.height,
          alignment: top ? Alignment.bottomCenter : Alignment.topCenter,
          child: Container(
            height: widget.height,
            width: widget.width,
            alignment: Alignment.center,
            child: Text(
              value,
              key: ValueKey(widget.value),
              style: TextStyle(
                color: const Color(0xFFE2E2E2),
                fontSize: fontSize / 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
