part of './tasks_bloc.dart';

abstract class TasksEvent {}

class LoadTasks extends TasksEvent {}

class AddTask extends TasksEvent {
  final String title;
  AddTask(this.title);
}

class UpdateTask extends TasksEvent {
  final String title;
  UpdateTask(this.title);
}

class ToggleComplete extends TasksEvent {
  final TaskItem isComplete;
  ToggleComplete(this.isComplete);
}

class DeleteTask extends TasksEvent {
  final int taskId;
  DeleteTask(this.taskId);
}
