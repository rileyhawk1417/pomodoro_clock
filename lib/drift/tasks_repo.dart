import 'package:pomodoro_clock/drift/db.dart';

class TasksRepo {
  final AppDatabase db;
  TasksRepo(this.db);

  Future<List<TaskItem>> getAllTasks() => db.getAllTasks();
  Future<void> addTask(TaskItemsCompanion task) =>
      db.into(db.taskItems).insert(task);

  Future<void> updateTask(TaskItemsCompanion task) =>
      db.update(db.taskItems).replace(task);

  Future<void> deleteTask(int id) =>
      (db.delete(db.taskItems)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> toggleComplete(TaskItem task) => db
      .update(db.taskItems)
      .replace(task.copyWith(isCompleted: !task.isCompleted));
}
