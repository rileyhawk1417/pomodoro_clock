import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_clock/drift/db.dart';
import 'package:pomodoro_clock/drift/tasks_repo.dart';
part './tasks_state.dart';
part './tasks_event.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepo tasksRepo;
  TasksBloc(this.tasksRepo) : super(InitialTask([])) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<ToggleComplete>(_onToggleComplete);
    add(LoadTasks());
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(TaskLoading([]));
    try {
      final tasks = await tasksRepo.getAllTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      // emit(TaskError('Failed to load tasks!'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    await tasksRepo.addTask(TaskItemsCompanion(
        title: Value(event.title), isCompleted: Value(false)));
    add(LoadTasks());
  }

  Future<void> _onToggleComplete(
      ToggleComplete event, Emitter<TasksState> emit) async {
    final currentTasks = state.tasks;
    final updatedTasks = currentTasks.map((task) {
      if (task.id == event.isComplete.id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    emit(TaskLoaded(updatedTasks));
    await tasksRepo.toggleComplete(event.isComplete);
    // add(LoadTasks());
  }
}
