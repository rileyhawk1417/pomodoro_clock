import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_clock/drift/db.dart';
import 'package:pomodoro_clock/drift/session_repo.dart';
part './sessions_event.dart';
part './sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionRepo sessionRepo;
  int? _currentSessionId;
  SessionsBloc(this.sessionRepo) : super(SessionInitial()) {
    on<LoadSessions>(_loadedSessions);
    on<SessionStarted>(_onSessionStarted);
    //on<SessionEnded>(_onSessionEnded);
    on<SessionCancelled>(_onSessionCancelled);
  }

  Future<void> _onSessionStarted(SessionStarted event, Emitter emit) async {
    final sessionCompanion = SessionsCompanion.insert(
        labelName: event.labelName,
        labelColor: event.labelColor,
        durationInSeconds: event.durationInSeconds,
        startedAt: Value(DateTime.now()));
    final sessionId = await sessionRepo.createSession(
        event.labelName, event.labelColor, event.durationInSeconds);
    _currentSessionId = sessionId;
    emit(SessionInProgress(sessionId));
  }

  //NOTE: Unimplemented SessionEnded
  Future<void> _onSessionCancelled(SessionCancelled event, Emitter emit) async {
    if (_currentSessionId != null) {
      sessionRepo.cancelSession(_currentSessionId!, true);
      emit(SessionComplete());
    }
  }

  Future<void> _loadedSessions(LoadSessions event, Emitter emit) async {
    final result = await sessionRepo.getAllSessions();
    emit(LoadedSessions(result));
  }
}
