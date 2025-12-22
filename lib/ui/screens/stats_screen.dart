import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);
  @override
  State<StatsScreen> createState() => _StatsScreen();
}

class _StatsScreen extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('Stats Screen!'));
  }
}
