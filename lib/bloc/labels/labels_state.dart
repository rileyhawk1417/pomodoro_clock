part of 'labels_bloc.dart';

class LabelsState extends Equatable {
  final List<Label> labels;
  const LabelsState(this.labels);

  @override
  List<Object?> get props => [labels];
}

class InitialLabel extends LabelsState {
  const InitialLabel(super.labels);

  @override
  String toString() => 'Init Tasks!';
}

class LabelsLoading extends LabelsState {
  const LabelsLoading(super.labels);

  @override
  String toString() => 'Init Tasks!';
}

class LabelsLoaded extends LabelsState {
  final List<Label> labels;
  const LabelsLoaded(this.labels) : super(labels);

  @override
  String toString() => 'Load Labels!';
}

class LabelsError extends LabelsState {
  const LabelsError(super.labels);

  @override
  String toString() => 'Label Error!';
}
