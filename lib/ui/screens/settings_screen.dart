import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pomodoro_clock/bloc/settings/settings_bloc.dart';
import 'package:pomodoro_clock/ui/screens/label_edit_screen.dart';
// import 'package:pomodoro_clock/ui/screens/home_screen.dart';
import 'package:pomodoro_clock/ui/widgets/timer_digit_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

const ringtoneList = [
  'assets/sounds/alarm.mp3',
  'assets/sounds/alarm_classic.mp3',
  'assets/sounds/alarm_clock.mp3',
  // 'assets/sounds/bad_to_the_bone_riff.mp3',
  // 'assets/sounds/loud_alarm.mp3',
  // 'assets/sounds/morning_alarm.mp3',
  'assets/sounds/morning_alarm.mp3',
  'assets/sounds/ohh_yeah.mp3',
  'assets/sounds/pink_panther.mp3',
  'assets/sounds/sweet_wake_up.mp3',
  'assets/sounds/waaaaaaaaaaaaau.mp3',
];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (settingsContext, state) {
      double workTime = settingsContext
          .read<SettingsBloc>()
          .state
          .settings
          .workDuration
          .toDouble();

      double breakTime = settingsContext
          .read<SettingsBloc>()
          .state
          .settings
          .breakDuration
          .toDouble();

      bool twelveHourNotation = settingsContext
          .read<SettingsBloc>()
          .state
          .settings
          .twelveHourNotation;

      bool showSeconds = settingsContext
          .read<SettingsBloc>()
          .state
          .settings
          .showSeconds;

      bool alwaysOn =
          settingsContext.read<SettingsBloc>().state.settings.alwaysOn;
      bool _twelveHourNotation = twelveHourNotation;
      bool _alwaysOn = alwaysOn;
      bool _showSeconds = showSeconds;
      return Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 28.0),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 0.5,
                height: 1.0,
                child: Container(
                  color: Colors.white,
                )),
            const Text('Timer Settings'),
            ListTile(
              title: const Text('Work Timer'),
              subtitle: const Text('The default work session timer'),
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: SimpleDialog(
                            title: const Text('Set a work time?'),
                            children: [
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Column(children: [
                                    Slider(
                                        value: workTime,
                                        onChanged: (value) {
                                          setState(() {
                                            workTime = value.toDouble();
                                          });
                                        },
                                        min: 0,
                                        max: 90),
                                    Text("${workTime.toInt()} minutes",
                                        style: const TextStyle(fontSize: 16.0)),
                                    Row(children: [
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            _handleSettingsOptions(
                                                'work_timer',
                                                settingsContext,
                                                workTime.toInt());
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Ok'))
                                    ]),
                                  ]);
                                },
                              ),
                            ]),
                      );
                    });
              },
            ),
            ListTile(
                title: const Text('Break Timer'),
                subtitle: const Text('The default break timer'),
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: SimpleDialog(
                              title: const Text('Set a break time?'),
                              children: [
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(children: [
                                      Slider(
                                          value: breakTime,
                                          onChanged: (value) {
                                            setState(() {
                                              breakTime = value.toDouble();
                                            });
                                          },
                                          min: 0,
                                          max: 90),
                                      Text("${breakTime.toInt()} minutes",
                                          style:
                                              const TextStyle(fontSize: 16.0)),
                                      Row(children: [
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () async {
                                              _handleSettingsOptions(
                                                  'break_timer',
                                                  settingsContext,
                                                  breakTime.toInt());
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Ok'))
                                      ]),
                                    ]);
                                  },
                                ),
                              ]),
                        );
                      });
                }),
            SizedBox(
                width: MediaQuery.of(context).size.width / 0.5,
                height: 1.0,
                child: Container(
                  color: Colors.white,
                )),
            const Text('Sound Settings'),
            ListTile(
                title: const Text('Break End Sound'),
                subtitle: const Text('The default end break timer sound'),
                onTap: () async {
                  await _showRingtoneOptions(
                      context, settingsContext, state, 'break_end_sound');
                }),
            ListTile(
                title: const Text('Work End Sound'),
                subtitle: const Text('The default end session timer sound'),
                onTap: () async {
                  await _showRingtoneOptions(
                      context, settingsContext, state, 'work_end_sound');
                }),
            SizedBox(
                width: MediaQuery.of(context).size.width / 0.5,
                height: 1.0,
                child: Container(
                  color: Colors.white,
                )),
            const Text('Session Settings'),
            ListTile(
                title: const Text('Labels'),
                subtitle: const Text('Change the labels for session timer'),
                onTap: () => settingsContext.go('/labels')),
            const Text('Display Settings'),
            SwitchListTile.adaptive(
                title: Text('Display ${_twelveHourNotation ? "24" : "12"}hr Notation'),
                subtitle: const Text('Toggle 24hr or 12hr clock display'),
                value: _twelveHourNotation,
                onChanged: (bool value) {
                  setState(() {
                    _twelveHourNotation = value;
                  });
                  _handleSettingsOptions("24hr_notation", settingsContext, value);
                }),
            SwitchListTile.adaptive(
                title: const Text('Always On Screen'),
                subtitle: const Text('Screen never turns off'),
                value: _alwaysOn,
                onChanged: (bool value) {
                  setState(() {
                    _alwaysOn = value;
                  });
                  _handleSettingsOptions("always_on", settingsContext, value);
                }),

            SwitchListTile.adaptive(
                title: const Text('Display Seconds'),
                subtitle: const Text('Display seconds on clock'),
                value: _showSeconds,
                onChanged: (bool value) {
                  setState(() {
                    _showSeconds = value;
                  });
                  _handleSettingsOptions("show_seconds", settingsContext, value);
                }),
          ],
        ),
      );
    });
  }

  Future<void> _playAlert(String source) async {
    final player = AudioPlayer();
    if (player.playing) {
      await player.stop();
    } else {
      if (source != '') {
        final audioSource = AudioSource.asset(source);
        await player.setAudioSource(audioSource);
        await player.setVolume(2.0);
        await player.play();
      }
    }
  }

  //NOTE: Release version requires permissions to create paths?
  Future<void> _songPlayer(AudioPlayer player, String value) async {
    if (player.playing) {
      await player.stop();
      final audioSource = AudioSource.asset(value);
      await player.setAudioSource(audioSource);
      await player.setVolume(2.0);
      await player.play();
    } else {
      final audioSource = AudioSource.asset(value);
      await player.setAudioSource(audioSource);
      await player.setVolume(2.0);
      await player.play();
    }
  }

  Future<void> _showRingtoneOptions(
      BuildContext context,
      BuildContext blocContext,
      SettingsState blocState,
      String settingName) async {
    String? selectedRingtone;

    final player = AudioPlayer();
    await showDialog(
        context: blocContext,
        builder: (context) {
          String? selectedRingtone;
          return AlertDialog(
              title: const Text('Select a tone'),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...ringtoneList.map((tone) {
                          return RadioListTile<String?>(
                              title: Text(tone.split(".mp3")[0].split("/")[2]),
                              value: tone,
                              groupValue: selectedRingtone,
                              onChanged: (value) async {
                                setState(() {
                                  selectedRingtone = value;
                                });

                                await _songPlayer(
                                    player, value ?? ringtoneList[0]);
                              });
                        }),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await player.stop();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      _handleSettingsOptions(
                          settingName, blocContext, selectedRingtone);
                      Navigator.of(context).pop();

                      await player.stop();
                    },
                    child: const Text('Ok'))
              ]);
        });
  }
}

void _handleSettingsOptions(
    String settingsName, BuildContext context, var value) {
  switch (settingsName) {
    case 'work_timer':
      context.read<SettingsBloc>().add(SetWorkDuration(duration: value));
      break;
    case 'break_timer':
      context.read<SettingsBloc>().add(SetBreakDuration(duration: value));
      break;
    case 'work_end_sound':
      context.read<SettingsBloc>().add(SetWorkEndSound(sound: value));
      break;
    case 'break_end_sound':
      context.read<SettingsBloc>().add(SetBreakEndSound(sound: value));
      break;
    case 'alert_repeat_count':
      context.read<SettingsBloc>().add(SetAlertRepeatCount(count: value));
    case '24hr_notation':
      context
          .read<SettingsBloc>()
          .add(SetTweleveHourNotation(isTwelveHourNotation: value));
      break;
    case 'always_on':
      context.read<SettingsBloc>().add(SetAlwaysOn(alwaysOn: value));
      break;
    case 'show_seconds':
      context.read<SettingsBloc>().add(SetShowSeconds(showSeconds: value));
      break;
    default:
      return;
  }
}
