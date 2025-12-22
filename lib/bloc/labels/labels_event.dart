part of 'labels_bloc.dart';

abstract class LabelsEvent {}

class LoadLabels extends LabelsEvent {}

class UpdateLabels extends LabelsEvent {
  final String labelName;
  final String labelColor;
  UpdateLabels(this.labelName, this.labelColor);
}

class AddLabels extends LabelsEvent {
  final String labelName;
  final String labelColor;
  AddLabels(this.labelName, this.labelColor);
}

class DeleteLabels extends LabelsEvent {
  final int labelId;
  DeleteLabels(this.labelId);
}
