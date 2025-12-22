part of 'sessions_bloc.dart';

abstract class SessionsState {}

class SessionInitial extends SessionsState {}

class SessionInProgress extends SessionsState {
  final int sessionId;
  SessionInProgress(this.sessionId);
}

class SessionComplete extends SessionsState {}

class LoadedSessions extends SessionsState {
  final List<Session> sessions;
  LoadedSessions(this.sessions);
}
