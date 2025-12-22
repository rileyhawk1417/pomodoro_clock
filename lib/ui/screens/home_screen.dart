import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_clock/ui/screens/digital_clock.dart';
import 'package:pomodoro_clock/ui/screens/settings_screen.dart';
import 'package:pomodoro_clock/ui/screens/stats_screen.dart';
import 'package:pomodoro_clock/ui/screens/timer_screen.dart';

List<IconData> iconList = [
  //Icons.access_alarm,
  Icons.access_time,
  //Icons.query_stats,
  Icons.settings
];
List<Widget> screenList = [
  //const TimerScreen(),
  const DigitalClockScreen(),
  //const StatsScreen(),
  const SettingsScreen()
];

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreen();
}

class _HomePageScreen extends State<HomePageScreen> {
  int _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: screenList[_bottomNavIndex],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // icons: iconList,
        tabBuilder: (int index, bool isActive) {
          return Icon(iconList[index], size: 24);
        },
        gapLocation: GapLocation.none,
        activeIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
