import 'package:drift/drift.dart';

class Labels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get labelColor => text()();
  TextColumn get labelName => text()();
}
