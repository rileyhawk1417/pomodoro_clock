part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final List<TaskItem> tasks;
  const TasksState(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class InitialTask extends TasksState {
  const InitialTask(super.tasks);

  @override
  String toString() => 'Init Tasks!';
}

class TaskLoading extends TasksState {
  const TaskLoading(super.tasks);
  @override
  String toString() => 'Tasks Loading';
}

class TaskLoaded extends TasksState {
  @override
  final List<TaskItem> tasks;
  const TaskLoaded(this.tasks) : super(tasks);
  @override
  String toString() => 'Loaded tasks!';
}

class TaskError extends TasksState {
  const TaskError(super.tasks);
  @override
  String toString() => 'Tasks failed to load';
}
