import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_clock/drift/labels_repo.dart';
import 'package:pomodoro_clock/drift/db.dart';

part 'labels_state.dart';
part 'labels_event.dart';

class LabelsBloc extends Bloc<LabelsEvent, LabelsState> {
  final LabelsRepo labelsRepo;
  LabelsBloc(this.labelsRepo) : super(InitialLabel([])) {
    on<LoadLabels>(_onLoadLabels);
    on<UpdateLabels>(_onUpdateLabels);
    on<AddLabels>(_onAddLabels);
    on<DeleteLabels>(_onDeleteLabels);
    add(LoadLabels());
  }

  Future<void> _onLoadLabels(
      LoadLabels event, Emitter<LabelsState> emit) async {
    final labels = await labelsRepo.getAllLabels();
    emit(LabelsLoaded(labels));
  }

  void _onUpdateLabels(UpdateLabels event, Emitter<LabelsState> emit) {}
  Future<void> _onAddLabels(AddLabels event, Emitter<LabelsState> emit) async {
    final labelsCompanion = LabelsCompanion.insert(
        labelName: event.labelName, labelColor: event.labelColor);
    await labelsRepo.addLabel(labelsCompanion);
    add(LoadLabels());
  }

  void _onDeleteLabels(DeleteLabels event, Emitter<LabelsState> emit) async {
    await labelsRepo.deleteLabel(event.labelId);
    add(LoadLabels());
  }
}
