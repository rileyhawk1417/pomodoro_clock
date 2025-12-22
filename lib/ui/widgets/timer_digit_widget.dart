import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_clock/bloc/session/sessions_bloc.dart';
import 'package:pomodoro_clock/bloc/settings/settings_bloc.dart';
import 'package:pomodoro_clock/bloc/tasks/tasks_bloc.dart';
import 'package:pomodoro_clock/bloc/timer/timer_bloc.dart';
import 'package:pomodoro_clock/drift/db.dart';
import 'package:pomodoro_clock/ui/digital_clock/landscape_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pomodoro_clock/ui/digital_clock/potrait_widget.dart';

class DigitalClockTimer extends StatelessWidget {
  const DigitalClockTimer(
      {Key? key,
      required this.second,
      required this.minute,
      required this.hour})
      : super(key: key);

  final String second;
  final String minute;
  final String hour;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPotrait = mediaQuery.orientation == Orientation.portrait;

    final alwaysOn =
        context.select((SettingsBloc bloc) => bloc.state.settings.alwaysOn);
    final showSeconds =
        context.select((SettingsBloc bloc) => bloc.state.settings.showSeconds);
    if (alwaysOn) {
      WakelockPlus.enable();
    }
    return BlocBuilder<TimerBloc, TimerState>(builder: (timerContext, state) {
      return Center(
        child: LayoutBuilder(
          builder: (layoutContext, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimerButtons(parentWidgetContext: layoutContext, state: state),
                isPotrait
                    ? DigitalClockPotraitWidget(
                        key: const ValueKey('potrait_layout'),
                        constraints: constraints,
                        second: second,
                        minute: minute,
                        showSeconds: showSeconds,
                        hour: hour)
                    : DigitalClockLandscapeWidget(
                        key: const ValueKey('landscape_layout'),
                        constraints: constraints,
                        showSeconds: showSeconds,
                        second: second,
                        minute: minute,
                        hour: hour),

                // )
              ],
            );
          },
        ),
      );
    });
  }
}

class TimerButtons extends StatelessWidget {
  const TimerButtons(
      {Key? key, required this.parentWidgetContext, required this.state})
      : super(key: key);
  final BuildContext parentWidgetContext;
  final TimerState state;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                parentWidgetContext.read<TimerBloc>().add(const TimerReset());
                parentWidgetContext
                    .read<SessionsBloc>()
                    .add(SessionCancelled());
              },
              icon: const Icon(Icons.stop)),
          /*
          IconButton(
              onPressed: () {
                final parentContext = parentWidgetContext;
                showFlexibleBottomSheet(
                  minHeight: 0,
                  initHeight: 0.5,
                  maxHeight: 1,
                  context: parentContext,
                  isSafeArea: true,
                  // isExpand: false,
                  builder: (context, scrollController, offset) {
                    return BlocProvider.value(
                      value: BlocProvider.of<TasksBloc>(parentContext),
                      child:
                          TasksBottomSheet(scrollController: scrollController),
                    );
                  },
                );
              },
              icon: const Icon(Icons.task_alt)),
                */
          state is TimerRunInProgress
              ? IconButton(
                  onPressed: () => parentWidgetContext
                      .read<TimerBloc>()
                      .add(const TimerPaused()),
                  icon: const Icon(Icons.pause))
              : IconButton(
                  onPressed: () => parentWidgetContext
                      .read<TimerBloc>()
                      .add(const TimerResumed()),
                  icon: const Icon(Icons.play_arrow)),
          IconButton(
              onPressed: () =>
                  parentWidgetContext.read<TimerBloc>().add(const TimerReset()),
              icon: const Icon(Icons.restart_alt))
        ]);
  }
}

class TasksBottomSheet extends StatelessWidget {
  const TasksBottomSheet({Key? key, required this.scrollController})
      : super(key: key);
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, tasksState) {
      if (tasksState is TaskLoading) {
        return Center(child: CircularProgressIndicator.adaptive());
      } else if (tasksState is TaskLoaded) {
        return Material(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TaskInput(),
                Flexible(
                  child: ListView.builder(
                      itemCount: tasksState.tasks.length,
                      controller: scrollController,
                      shrinkWrap: true,
                      itemBuilder: (listContext, index) {
                        final task = tasksState.tasks[index];
                        return TaskWidget(task: task);
                      }),
                ),
              ],
            ),
          ),
        );
      } else if (tasksState is TaskError) {
        return Text('Failed to load tasks');
      } else {
        return Container();
      }
    });
  }
}

class TaskInput extends StatelessWidget {
  const TaskInput({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();
    return Row(children: [
      Flexible(
          child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: 'Add a new task',
          border: OutlineInputBorder(),
        ),
      )),
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          context
              .read<TasksBloc>()
              .add(AddTask(_textEditingController.value.text));
        },
      )
    ]);
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  final TaskItem task;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ValueKey(task.id),
      width: MediaQuery.of(context).size.width / 0.4,
      child: ListTile(
        title: Text(task.title),
        onTap: () {
          context.read<TasksBloc>().add(ToggleComplete(task));
        },
        trailing: SizedBox(
            width: 12,
            child: task.isCompleted
                ? Icon(Icons.check_box_outlined)
                : Icon(Icons.check_box_outline_blank)),
      ),
    );
  }
}
