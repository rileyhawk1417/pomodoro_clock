import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_clock/ui/screens/digital_clock.dart';
import 'package:pomodoro_clock/ui/screens/home_screen.dart';
import 'package:pomodoro_clock/ui/screens/label_edit_screen.dart';
import 'package:pomodoro_clock/ui/screens/settings_screen.dart';
import 'package:pomodoro_clock/ui/screens/stats_screen.dart';
import 'package:pomodoro_clock/ui/screens/timer_screen.dart';
import 'package:pomodoro_clock/ui/themes/dark_mode.dart';
import 'package:pomodoro_clock/ui/themes/light_mode.dart';
import 'package:pomodoro_clock/hive/settings_model.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:pomodoro_clock/bloc/labels/labels_bloc.dart';
import 'package:pomodoro_clock/bloc/session/sessions_bloc.dart';
import 'package:pomodoro_clock/bloc/tasks/tasks_bloc.dart';
import 'package:pomodoro_clock/bloc/timer/tick.dart';
import 'package:pomodoro_clock/drift/db.dart';
import 'package:pomodoro_clock/drift/labels_repo.dart';
import 'package:pomodoro_clock/drift/session_repo.dart';
import 'package:pomodoro_clock/drift/tasks_repo.dart';
import 'package:pomodoro_clock/bloc/timer/timer_bloc.dart';
import 'package:pomodoro_clock/bloc/settings/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await BoxCollection.open('pomodoro_clock_box', {'settings'},
      path: './pomodoro_clock');
  Hive.registerAdapter(SettingsModelAdapter());
  Hive.registerAdapter(LabelsModelAdapter());
  await Hive.openBox<SettingsModel>('settings');
  runApp(const MyApp());
}

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => HomePageScreen()),
  GoRoute(path: '/timer', builder: (context, state) => TimerScreen()),
  GoRoute(path: '/clock', builder: (context, state) => DigitalClockScreen()),
  GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
  GoRoute(path: '/labels', builder: (context, state) => LabelEditScreen()),
  GoRoute(path: '/stats', builder: (context, state) => StatsScreen()),
]);

final appDB = AppDatabase();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsBox = Hive.box<SettingsModel>('settings');
    return MultiBlocProvider(
        providers: [
          BlocProvider<TasksBloc>(
            create: (_) => TasksBloc(
              TasksRepo(
                appDB,
              ),
            )..add(LoadTasks()),
          ),
          BlocProvider<TimerBloc>(
            create: (_) => TimerBloc(
              ticker: const Tick(),
              settingsBloc: SettingsBloc(settingsBox)
                ..add(
                  LoadSettings(),
                ),
            ),
          ),
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc(settingsBox)
              ..add(
                LoadSettings(),
              ),
          ),
          BlocProvider<SessionsBloc>(
            create: (_) => SessionsBloc(
              SessionRepo(
                appDB,
              ),
            )..add(LoadSessions()),
          ),
          BlocProvider<LabelsBloc>(
            create: (_) => LabelsBloc(
              LabelsRepo(
                appDB,
              ),
            )..add(LoadLabels()),
          )
        ],
        child: MaterialApp.router(
          title: 'Pomodoro Clock',
          themeMode: ThemeMode.system,
          theme: lightTheme,
          darkTheme: darkTheme,
          routerConfig: _router,
          // home: const DigitalClockScreen(),
          //home: const HomePageScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
