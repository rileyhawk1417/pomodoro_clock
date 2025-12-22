import 'package:drift/drift.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get durationInSeconds => integer()();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get wasCancelled => boolean().withDefault(Constant(false))();
  TextColumn get labelColor => text()();
  TextColumn get labelName => text()();
}
