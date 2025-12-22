import 'package:drift/drift.dart';

import './db.dart';

class SessionRepo {
  final AppDatabase db;
  SessionRepo(this.db);

  Future<List<Session>> getAllSessions() => db.getAllSessions();
  Future<void> addSession(SessionsCompanion session) =>
      db.into(db.sessions).insert(session);

  Future<int> createSession(
      String labelName, String labelColor, int durationInSeconds,
      {bool wasCancelled = false}) {
    return db.into(db.sessions).insert(SessionsCompanion.insert(
        durationInSeconds: durationInSeconds,
        wasCancelled: Value(wasCancelled),
        labelName: labelName,
        labelColor: labelColor));
  }

  Future<void> cancelSession(int sessionId, bool wasCancelled) =>
      (db.update(db.sessions)..where((item) => item.id.equals(sessionId)))
          .write(SessionsCompanion(wasCancelled: Value(wasCancelled)));
/*
  Future<List<Session>> getSessionsForTasks(int taskId) {
    return (db.select(db.sessions)..where((task) => task.taskId.equals(taskId)))
        .get();
  }

  Future<List<SessionWithTask>> getTasksWithSessions() {
    final query = db.select(db.taskItems).join([
      leftOuterJoin(db.sessions, db.sessions.taskId.equalsExp(db.taskItems.id))
    ]);
    return query.map((row) {
      return SessionWithTask(
          task: row.readTable(db.taskItems),
          session: row.readTable(db.sessions));
    }).get();
  }
    */

  /*
  //TODO: Figure this out?
  Future<List<SessionWithTask>> getSessionsWithTasks(
      SessionsCompanion sessions, TaskItemsCompanion taskItems) {
    final query =
        db.select(sessions).join([innerJoin(taskItems, sessions.taskId)]);
  }
*/

  Future<void> deleteSession(int id) =>
      (db.delete(db.sessions)..where((item) => item.id.equals(id))).go();

  //TODO: Add update session?
  /*
  Future<void> updateSession(SessionsCompanion session) =>
      db.update(db.sessions).replace(item.copyWidth());
        */
}

class SessionWithTask {
  final Session session;
  final TaskItem task;
  SessionWithTask({required this.session, required this.task});
}
