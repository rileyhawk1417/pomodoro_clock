import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import './schemas/labels.dart';
import './schemas/sessions.dart';
import './schemas/tasks.dart';

part 'db.g.dart';

@DriftDatabase(tables: [TaskItems, Sessions, Labels])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  Future<List<TaskItem>> getAllTasks() => select(taskItems).get();
  Future<List<Session>> getAllSessions() => select(sessions).get();
  Future<List<Label>> getAllLabels() => select(labels).get();
  /*
  Future<List<Session>> getSessionsForTask(int taskId) {
    return (select(sessions)..where((s) => s.taskId.equals(taskId))).get();
  }
*/
/*
  Future<int> totalTimeSpentOnTask(int taskId) async {
    final sessions = await getSessionsForTask(taskId);
    return sessions.fold(0, (total, s) => total + s.durationInSeconds);
  }
  */

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'pomodoro_clock',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
