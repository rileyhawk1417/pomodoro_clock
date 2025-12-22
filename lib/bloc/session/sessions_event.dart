part of 'sessions_bloc.dart';

abstract class SessionsEvent {}

class SessionStarted extends SessionsEvent {
  final String labelName;
  final String labelColor;
  final int durationInSeconds;
  SessionStarted(this.labelName, this.labelColor, this.durationInSeconds);
}

class SessionCancelled extends SessionsEvent {}

class SessionEnded extends SessionsEvent {}

class LoadSessions extends SessionsEvent {}
