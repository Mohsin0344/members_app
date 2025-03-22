import 'package:flutter/material.dart';

@immutable
sealed class AppState {
  const AppState();
}

final class InitialState extends AppState {
  const InitialState();
}

final class LoadingState extends AppState {
  const LoadingState();
}

final class LoadingStateWithProgress extends AppState {
  final double progress;

  const LoadingStateWithProgress({
    required this.progress,
  });
}

final class SuccessState<T> extends AppState {
  final T data;

  const SuccessState({
    required this.data,
  });
}

final class ApiErrorState extends AppState {
  final String? error;

  const ApiErrorState({this.error});
}

final class TimeoutState extends AppState {
  const TimeoutState();
}

final class InternetErrorState extends AppState {
  const InternetErrorState();
}

final class VersionErrorState extends AppState {
  const VersionErrorState();
}

final class UnknownErrorState extends AppState {
  final String? error;

  const UnknownErrorState({this.error});
}


