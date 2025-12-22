import './db.dart';

class LabelsRepo {
  final AppDatabase db;
  LabelsRepo(this.db);

  Future<List<Label>> getAllLabels() => db.getAllLabels();
  Future<void> addLabel(LabelsCompanion label) =>
      db.into(db.labels).insert(label);
  Future<void> updateLabel(
    LabelsCompanion label,
  ) =>
      (db.update(db.labels).replace(label.copyWith(
          labelColor: label.labelColor, labelName: label.labelName)));
  Future<void> deleteLabel(int labelId) {
    print(labelId);
    return (db.delete(db.labels)..where((item) => item.id.equals(labelId)))
        .go();
  }
}
